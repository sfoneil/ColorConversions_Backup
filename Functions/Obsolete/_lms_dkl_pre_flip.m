function spaceOut = lms_dkl(spaceConv, lmsBackground, Target, varargin)
%LMS_DKL Convert between LMS cone activations and DKL Lum, L-M, S-LM coordinates
%   dkl = lms_dkl(direction, backgroundColor, targetColor)
%
%   Where:
%       direction is character string 'lms2dkl' (this function) or
%          'dkl2lms' for opposite direction.
%       lmsBack: reference color in LMS units, use rgb2lms() first
%          if needed. Can be a specified White Point loaded from
%          illuminants.mat
%       lmsTarget: is generated in reference to lmsBack

%TODO parsed option for pooled cone contrast, where:
% NORMALIZE
% Cl = (LconeTarget - LconeBackground) / LconeBackground
% Repeat for M, S
% and PooledC = sqrt(Cl + Cm + Cs)

%[colorInfo, phos] = loadCI();

%% Get Inputs

%colorInfo = loadCI(); % for future use?

p = inputParser;

% Validator(s)
validConversion = {'lms2dkl', 'dkl2lms'};
validColorInput = @(x) size(x, 2) == 3;
validSpaces = {'cartesian', 'polar'};
validOrder = {'LMSLMLum', 'LumLMSLM'};
validDirections = {'Regular','Classic'};

addRequired(p, 'spaceConv', @(x) any(validatestring(x, validConversion)));
addRequired(p, 'lmsBackground', validColorInput);
addRequired(p, 'Target', validColorInput);

%Todo add polar conversion
addParameter(p, 'Space', 'Cartesian', @(x) any(validatestring(x, validSpaces)));
% Use default [L-M, S-L+M, L+M] or Westland book [L+M, S-L+M, L-M]
addParameter(p, 'CartOrder', 'LMSLMLum', @(x) any(validatestring(x, validOrder)));
% Use right=red up=blue left=green down=yellow or rotated
addParameter(p, 'Direction', 'Regular', @(x) any(validatestring(x, validDirections)));

% Get values out
parse(p, spaceConv, lmsBackground, Target, varargin{:})

%% Math
if strcmpi(spaceConv,'dkl2lms')
    % Change order if requested, now [Lum LM SLM]
    Target = DKL_reorder(Target, 'CartOrder', p.Results.CartOrder);

 
    % Now that it is in order [Lum LM SLM] rotate if needed (default)
    Target = DKL_flip(Target, 'Direction', p.Results.Direction);
%     if strcmpi(p.Results.Direction, 'Classic')
%         warning(['Argument ''Classic'' puts red left and blue down per original DKL paper. ' ...
%             'This is now atypical. Use argument ''Regular'' to use typical standards.'])
%     else %Not doing elseif, typo means use the regular one
%         Target = [Target(:,1), Target(:,2:3).*-1];
%     end
end

% Transpose for matrix math
if size(Target, 2) == 3; Target = Target'; end
if size(lmsBackground, 2) == 3; lmsBackground = lmsBackground'; end


%% Math

% Get difference
if strcmpi(spaceConv,'lms2dkl')
    lmsDiff =  lmsBackground - Target;
    %dkl2lms() is at end
end

% Matrix for conversion
toDKLMat = [1 1 0; ...
    1 -lmsBackground(1)/lmsBackground(2) 0; ...
    -1 -1 (lmsBackground(1)+lmsBackground(2))/lmsBackground(3)];

fromDKLMat = inv(toDKLMat);

% Fixed [Lum LM SLM] order per above
lum  = fromDKLMat(:,1);
LM = fromDKLMat(:,2);
S  = fromDKLMat(:,3);

% Pool cone contrast
lumPooled  = norm(lum./lmsBackground);  % k(LUM)
LMPooled = norm(LM./lmsBackground); % k(L-M)
SPooled  = norm(S./lmsBackground);  % k(S-LUM)

% Unit response
lumUnit = lum  / lumPooled;
LMUnit = LM / LMPooled;
SUnit  = S / SPooled;

% normalise B to obtain the normalising constants
lumNorm = toDKLMat * lumUnit;
LMNorm = toDKLMat * LMUnit;
SNorm = toDKLMat * SUnit;

% Normalizing constants
diagConst=[1./lumNorm(1) 0 0; ...
    0 1./LMNorm(2) 0;  ...
    0 0 1./SNorm(3)];

% Get final transform
finalTransform = diagConst * toDKLMat;

% Choose final result based on space
if strcmpi(spaceConv,'lms2dkl')
    dklRadians = (finalTransform * lmsDiff)'; % Cartesian in radians, do we want degrees?
    spaceOut = dklRadians;
    % Save last DKL to colorInfo, optionally for MB conversions.
    % Will need to save .mat manually?
    %saveDKL(spaceOut, colorInfo);
    spaceOut = DKL_flip(spaceOut, 'Direction', p.Results.Direction);
%     if ~strcmpi(p.Results.Direction, 'Classic')
%         spaceOut = [spaceOut(:, 1), spaceOut(:,2:3).*-1];
%     end
    % Change order, by default
    spaceOut = DKL_reorder(spaceOut, 'CartOrder', p.Results.CartOrder);
%     if strcmpi(p.Results.CartOrder, 'LMSLMLum')
%         spaceOut = [spaceOut(:,2), spaceOut(:,3), spaceOut(:,1)];
%     end

elseif strcmpi(spaceConv,'dkl2lms')
    %ftInv = inv(finalTransform);
    %lmsDiff = ftInv * target;
    lmsDiff = finalTransform\Target; % Faster than previous 2 lines
    lms = (lmsBackground - lmsDiff)';
    spaceOut = lms;
    %saveLum(spaceOut, 2, colorInfo); % todo k is an option?
end

% todo spherical coordinates, see above note about radians?

end