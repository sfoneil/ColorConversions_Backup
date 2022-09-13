function spaceOut = lms_dkl(spaceConv, Target, varargin)
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

p = iparse(Target, varargin{:});
% p = inputParser;
% p.KeepUnmatched = true;
% Validator(s)
% validConversion = {'lms2dkl', 'dkl2lms'};
% validColorInput = @(x) size(x, 2) == 3;
% validSpaces = {'Cartesian', 'Spherical', 'Polar'};
% % validOrder = {'LMSLMLum', 'LumLMSLM'};
% validDirections = {'Regular','Classic'};

% addRequired(p, 'spaceConv', @(x) any(validatestring(x, validConversion)));
% addRequired(p, 'lmsBackground', validColorInput);
% addRequired(p, 'Target', validColorInput);
% 
% %Todo add polar conversion
% addParameter(p, 'Space', 'Cartesian', @(x) any(validatestring(x, validSpaces)));
% % Use default [L-M, S-L+M, L+M] or Westland book [L+M, S-L+M, L-M]
% %addParameter(p, 'CartOrder', 'LMSLMLum', @(x) any(validatestring(x, validOrder)));
% % Use right=red up=blue left=green down=yellow or rotated
% addParameter(p, 'Direction', 'Regular', @(x) any(validatestring(x, validDirections)));

% Get values out
% parse(p, spaceConv, lmsBackground, Target, varargin{:})
backgroundRGB = p.Results.Background;
backgroundLMS = rgb2lms(backgroundRGB);

axisScale = p.Results.AxisScale;
origin = p.Results.Origin;
%% Math
if strcmpi(spaceConv,'dkl2lms')
    
    %     % Change order if requested, now [Lum LM SLM]
    Target = DKL_working_space('LumFirst', Target);
    %     if ~strcmpi(p.Results.CartOrder, 'LumLMSLM') % If input is lum at end
    %         Target = DKL_reorder(Target, 'LumLMSLM'); % Then change to working space
    %     end
    %

    % Shift based on specified scaling and origin
    Target = Target ./ [1, axisScale]; %Don't scale lum, scale LM SLM if asked
    Target = Target + [0, origin];

% 
% 
%     % Now that it is in order [Lum LM SLM] rotate if needed (default)
%     if ~strcmpi(p.Results.Direction, 'Classic')
%         Target = DKL_flip(Target, 'Classic');
%     end
    % Target = DKL_flip(Target, 'Direction', p.Results.Direction);
    %     if strcmpi(p.Results.Direction, 'Classic')
    %         warning(['Argument ''Classic'' puts red left and blue down per original DKL paper. ' ...
    %             'This is now atypical. Use argument ''Regular'' to use typical standards.'])
    %     else %Not doing elseif, typo means use the regular one
    %         Target = [Target(:,1), Target(:,2:3).*-1];
    %     end
end

% Transpose for matrix math
if size(Target, 2) == 3; Target = Target'; end
if size(backgroundLMS, 2) == 3; backgroundLMS = backgroundLMS'; end


%% Math

% Get difference
if strcmpi(spaceConv,'lms2dkl')
    lmsDiff =  backgroundLMS - Target;
    %dkl2lms() is at end
end

% Matrix for conversion
toDKLMat = [1 1 0; ...
    1 -backgroundLMS(1)/backgroundLMS(2) 0; ...
    -1 -1 (backgroundLMS(1)+backgroundLMS(2))/backgroundLMS(3)];

fromDKLMat = inv(toDKLMat);

% Fixed [Lum LM SLM] order per above
lum  = fromDKLMat(:,1);
LM = fromDKLMat(:,2);
S  = fromDKLMat(:,3);

% Pool cone contrast
lumPooled  = norm(lum./backgroundLMS);  % k(LUM)
LMPooled = norm(LM./backgroundLMS); % k(L-M)
SPooled  = norm(S./backgroundLMS);  % k(S-LUM)

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
    if strcmpi(p.Results.Space, 'Spherical') || strcmpi(p.Results.Space, 'Polar')
        spaceOut = dkl2sph(spaceOut);
    end
    % Save last DKL to colorInfo, optionally for MB conversions.
    % Will need to save .mat manually?
    %saveDKL(spaceOut, colorInfo);
    %  
    spaceOut = DKL_working_space('LumLast', spaceOut);
%     if ~strcmpi(p.Results.Direction, 'Classic')
%         spaceOut = DKL_flip(spaceOut, 'Direction', 'Regular');
%     end
%     % Change order, by default
%     if ~strcmpi(p.Results.CartOrder, 'LMSLMLum')
%         spaceOut = DKL_reorder(spaceOut, 'LMSLMLum');
%     end

    %     if strcmpi(p.Results.CartOrder, 'LMSLMLum')
    %         spaceOut = [spaceOut(:,2), spaceOut(:,3), spaceOut(:,1)];
    %     end

elseif strcmpi(spaceConv,'dkl2lms')
    %ftInv = inv(finalTransform);
    %lmsDiff = ftInv * target;
    lmsDiff = finalTransform\Target; % Faster than previous 2 lines
    lms = (backgroundLMS - lmsDiff)';
    spaceOut = lms;
    %saveLum(spaceOut, 2, colorInfo); % todo k is an option?
end

% todo spherical coordinates, see above note about radians?

end