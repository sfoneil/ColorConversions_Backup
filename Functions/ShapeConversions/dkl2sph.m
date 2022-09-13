function [DKLdegrees] = dkl2sph(DKLradians, varargin)
%DKL2SPH Convert Cartesian coordinates to spherical DKL coordinates.
%   Cartesian is radians [LM S Lum] by default
%   Spherical is degrees [relativeLuminance, chromaticityAngle, contrast]  by default


%% Parse inputs
validOrder = {'RAE', 'EAR'};
validDirections = {'Regular','Classic'};
validOrder = {'LMSLMLum', 'LumLMSLM'};
p = inputParser;
addRequired(p, 'DKLradians', @isnumeric);
addParameter(p, 'CartOrder', 'LMSLMLum', @(x) any(validatestring(x, validOrder)));
addParameter(p, 'SphOrder', 'EAR', @(x) any(validatestring(x, validOrder)));
addParameter(p, 'Direction', 'Regular', @(x) any(validatestring(x, validDirections)));
parse(p, DKLradians, varargin{:});
%todo atan2

if strcmpi(p.Results.CartOrder, 'LumLMSLM')
    warning(['Argument ''LumLMSLM'' puts input in [Luminance LM SLM] order. ' ...
        'Use ''LMSLMLum'' for [LM SLM Luminance] order.']);
else
    DKLradians = [DKLradians(:,3), DKLradians(:,1), DKLradians(:,2)];
end

%% Radius, contrast
isolum_len = sqrt(DKLradians(:,2) .^ 2 + DKLradians(:,3) .^2);

%% Elevation, luminance
if isolum_len == 0
    elevationRadians = atan(DKLradians(:,1) ./ 0.000000001);
else
    elevationRadians = atan(DKLradians(:,1) ./ isolum_len);
end
elevationDegrees = -rad2deg(elevationRadians);

%% Azimuth, chromaticity
% Correction for very small values
THRESH = 0.000001;
nearZero = DKLradians(:,2) > -THRESH & DKLradians(:,2) < THRESH ...
    & DKLradians(:,3) > -THRESH & DKLradians(:,3) < THRESH;
azimuthRadians = zeros(size(elevationRadians));

% Convert to degrees
azimuthDegrees = atan2d(DKLradians(:,3), DKLradians(:,2));
% Flip negative values
degToFlip = find(azimuthDegrees<0);
azimuthDegrees(degToFlip) = mod(azimuthDegrees(degToFlip)+360,360);

radius = isolum_len;
radius(nearZero) = sqrt(DKLradians(nearZero,1) .^ 2);
azimuthDegrees(isnan(azimuthDegrees)) = 0; % Check if neceesary?

% Switch order as needed
if strcmpi(p.Results.SphOrder, 'RAE')
    DKLdegrees = [radius azimuthDegrees elevationDegrees];
elseif strcmpi(p.Results.SphOrder,'EAR')
    DKLdegrees = [elevationDegrees azimuthDegrees radius];
end

end