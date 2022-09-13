function outData = adjustAngles(DKL, varargin)
%ADJUSTANGLES Determine adjusted LM and SLM in DKL space based on
%empirically-derived individual minimum motion data.
%   This function is optional, and should be only used if the individual
%   participant's axes data has been collected.
%   DKL = DKL coordinates you want to convert / used in current trial
%   RotationAngles = actual angle of[L-M, S-L+M] or [horizontal vertical]
%       axes. e.g if [-5 98], it rotates
%       horizontal axis rotated clockwise and vertical counterclockwise
%   -5 is equivalent to 355


%todo: integrate with dklGamut(): what if gamut changes with MM?
[ci, phos] = loadCI();

%% Get Inputs
p = inputParser;

% Validator(s)
% validWavelengthMatrix = @(x) isnumeric(x) && size(x,2) == 4;
validColorInput = @(x) size(x,2) == 3;

% Required parameters to run this
addRequired(p, 'DKL')%, validColorInput)

% Axis scaling
defRef = [80 0 -0.01; 0 80 .01; 0 0 0];
addParameter(p, 'Contrast', 80, @isnumeric)
addParameter(p, 'RotationAngles', [0 90], @isnumeric);
addParameter(p, 'MinimumMotion', -1, @isnumeric);
addParameter(p, 'Space', 'MW');
addParameter(p, 'Visualize', false);

% Get values out
parse(p, DKL, varargin{:})

if isa(DKL, 'trival')
    data = DKL.Value;
    luminance = DKL.Luminance;
else
    data = DKL;
    luminance = DKL(:,3);
end

  
contrast = p.Results.Contrast;
rot = p.Results.RotationAngles;
space = p.Results.Space;

% Add back in original luminance
% Currently accepts scalar first value. Is there a need for multiple
% base luminances in the future? Will have to fix if so
mm = p.Results.MinimumMotion;
% Which is right? I think the first is better...? Less difference anyway
mm(1:2) = mm(1:2) .* luminance(1);
%mm(1:2) = mm(1:2) .* luminance(1) + luminance(1);

% Adjust contrast variable to 2x2
if numel(contrast) == 1
    contrast = [-contrast contrast; -contrast contrast];
elseif numel(contrast) == 2
    contrast = [-contrast(1) contrast(1); -contrast(2) contrast(2)];
elseif numel(contrast) == 4
    % Keep it
else
    error('Contrast possibly wrong? Should be length 1, 2, or 4')
end

axisRanges = contrast; %e.g. -80 to 80

%% Do rotation
% Get x, y of individual angle, col1=lm col2=s
LMrot = rot(1);
Srot = rot(2);

% Convert angle to x, y
rotMat = [cosd(LMrot) cosd(Srot);
    sind(LMrot) sind(Srot)];

% Transform DKL [LM SLM]
outDKL = (rotMat * data(:,1:2)')';

%% Minimum motion correction
if mm ~= -1
    % Minimum motion conversion matrix
    mmMat = [contrast(1,2) 0 mm(1);
        0 contrast(2,2) mm(2);
        0 0 mm(3)];

    % Normalize DKL
    outDKL = [(outDKL(:,1) ./ axisRanges(1,2)), (outDKL(:,2) ./ axisRanges(2,2))];

    % Add lum in
    outDKL = [outDKL, luminance]; %Normalize
    LMPlane = mmMat(1,:);
    SPlane = mmMat(2,:);
    RefPlane = mmMat(3,:);
    normalized = cross(LMPlane-SPlane, LMPlane-RefPlane);
    newLum = -(normalized(1) * outDKL(:,2) + normalized(2) * outDKL(:,3)) / normalized(3);  
   % newLum = luminance + newLum;

    outDKL = [outDKL(:,1) * axisRanges(1,2), outDKL(:,2) * axisRanges(2,2), newLum];
    if strcmpi(space, 'MW') || strcmpi(space, 'Webster')
        outData = trival({'MW', outDKL, outDKL(:,3)});
    elseif strcmpi(space, 'DKL')
        outData = outDKL;
    end
end
%% Plot only if Visualize == true
if p.Results.Visualize == true
    figure;
    orig = []; adj = [];
    for i = 0:10:350
        angle = [cosd(i), sind(i)];
        orig = [orig; angle];
        adjusted = rotMat * orig';
        adj = [adj; adjusted'];
    end
    plot(orig(:,1), orig(:,2),'ro', ...
        adj(:,1),adj(:,2),'bo')
    axis([-1.5 1.5 -1.5 1.5])
    axis square
    hold on
    plot([1 -1],[0 -0], 'r-',[0 0],[1 -1], 'r-')
    plot([cosd(LMrot) -cosd(LMrot)], [sind(LMrot), -sind(LMrot)], 'b-', ...
        [cosd(Srot) -cosd(Srot)], [sind(Srot) -sind(Srot)],'b-')
    plot(outDKL(2), outDKL(3),'k*')
    ang = atan2(outDKL(3), outDKL(2))/pi*180; % Give absolute angle
    if ang < 0; ang = 360 + ang; end
    text(-1, 1, num2str(ang))
end
end

