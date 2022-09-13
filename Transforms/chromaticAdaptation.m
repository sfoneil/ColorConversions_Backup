function [adaptedXYZ, finalMatrix] = chromaticAdaptation(XYZ, WPfrom, WPto, varargin)
%CHROMATICADAPTATION Function to adapt XYZ values from one white point to
%another, using one of 3 methods. This is typically for converting from
%linear RGB to or from XYZ when space is changed or not available.
%   adaptedXYZ = chromaticAdaptation(XYZ, 'D65_2', 'D50_2'); takes XYZ
%   value with D65 white point, adapts it to D50 using Bradford method, and
%   returns resulting adaptedXYZ
%   adaptedXYZ = chromaticAdaptation(XYZ, 'C_2', 'E', 'vk'); converts from
%   illuminant C to illuminant E (equal energy) using von Kries method.
%   [adaptedXYZ, finalMatrix] = chromaticAdaptation(XYZ, 'D65_2','D65_10');
%   converts D65 2-degree observer to D65 10-degree observer, and also
%   returns the transformation matrix used for the conversion.

% todo xyY > xyY via XYZ > XYZ

%% Parse inputs
wpValidator = @(x) ischar(x) || isstring(x) || isempty(x) || isnumeric(x);
convValidator = @(x) ischar(x) || isempty(x);
p = inputParser;
addRequired(p, 'XYZ');%, @isnumeric)
addRequired(p, 'WPfrom', wpValidator);
addRequired(p, 'WPto', wpValidator);
addParameter(p, 'Method', 'Bradford', convValidator);
addParameter(p, 'ColorSpace', 'XYZ', @(x) ischar(x) || isstring(x))
parse(p, XYZ, WPfrom, WPto, varargin{:});
method = p.Results.Method;

% Fix later, should be automatically case insensitive but still isnt
WPfrom = upper(WPfrom);
WPto = upper(WPto);

if strcmpi(p.Results.ColorSpace, 'xyY')
    XYZ=xyy2xyz(XYZ);
end
%% Get white points
load illuminants.mat %todo 10 degrees?
sourceWP = eval("si." + WPfrom);
destinationWP = eval("si." + WPto);

%% Fixed conversion matrices, Bradford is preferred and default
XYZScaleMat = eye(3);
XYZScaleInv = eye(3);
BradfordScaleMat = [0.8951000  0.2664000 -0.1614000;
    -0.7502000  1.7135000  0.0367000;
    0.0389000 -0.0685000  1.0296000];
BradfordScaleInv = inv(BradfordScaleMat);
vonKriesScaleMat = [ 0.4002400  0.7076000 -0.0808100;
    -0.2263000  1.1653200  0.0457000;
    0.0000000  0.0000000  0.9182200];
vonKriesScaleInv = inv(vonKriesScaleMat);

%% Chose conversion matrices
if strcmpi(method, 'XYZ') || strcmpi(method, 'XYZScaling')
    forwardMat = XYZScaleMat;
    invMat = XYZScaleInv;
elseif strcmpi(method, 'Bradford')
    forwardMat = BradfordScaleMat;
    invMat = BradfordScaleInv;
elseif strcmpi(method, 'von Kries') || strcmpi(method, 'vonkries') || ...
        strcmpi(method, 'kries') || strcmpi(method, 'vk')
    forwardMat = vonKriesScaleMat;
    invMat = vonKriesScaleInv;
end

%% Create matrices and return results
coneSource = forwardMat * sourceWP'; % Get cone responses, source WP
coneDest = forwardMat * destinationWP'; % Get cone responses, destination WP
ratioMat = diag(coneDest./coneSource); % Ratio of dest/source in diagonal
%ratioMat = cDest./cSource .* eye(3); 
finalMatrix = invMat * ratioMat * forwardMat; % Matrix that converts XYZs-->XYZd
adaptedXYZ = (finalMatrix * XYZ')';

if strcmpi(p.Results.ColorSpace, 'xyY')
    adaptedXYZ = xyz2xyy(adaptedXYZ);
end
end

