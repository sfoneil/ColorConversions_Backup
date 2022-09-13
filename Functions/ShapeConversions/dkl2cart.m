function [DKLradians] = dkl2cart(DKLdegrees, varargin)
%DKL2CART Convert spherical DKL coordinates to Cartesian coordinates.
%   Spherical is degrees [relativeLuminance, chromaticityAngle, contrast] by default
%   Cartesian is radians [LM S Lum] by default

%% Parse inputs
validCartOrder = {'RAE', 'EAR'};
validDirections = {'Regular','Classic'};
validSphOrder = {'LMSLMLum', 'LumLMSLM'};
p = inputParser;
addRequired(p, 'DKLdegrees', @isnumeric);
addParameter(p, 'CartOrder', 'LMSLMLum', @(x) any(validatestring(x, validCartOrder)));
addParameter(p, 'SphOrder', 'EAR', @(x) any(validatestring(x, validSphOrder)));
addParameter(p, 'Direction', 'Regular', @(x) any(validatestring(x, validDirections)));
parse(p, DKLdegrees, varargin{:});

% Switch order as needed
if strcmpi(p.Results.SphOrder, 'RAE')
    % [Hue, Contrast, Luminance]
    [radius, azimuthDegrees, elevationDegrees] = ...
        deal(DKLdegrees(:,1), DKLdegrees(:,2), -DKLdegrees(:,3));
elseif strcmpi(p.Results.SphOrder,'EAR')
    % [Luminance, Hue, Contrast]
    [elevationDegrees, azimuthDegrees, radius] = ...
    deal(DKLdegrees(:,1), DKLdegrees(:,2), -DKLdegrees(:,3));
end


azimuthRadians = deg2rad(azimuthDegrees);
elevationRadians = deg2rad(elevationDegrees);

%% Convert to Cartesian

% Get coordinates that are pure L+M luminance
pureLuminance = (elevationDegrees==90) | (elevationDegrees==-90);

% Get all values in radians
lum = radius .* tan(elevationRadians);
chro_LM = radius .* cos(azimuthRadians);
chro_S = radius .* sin(azimuthRadians);

% Revert values previously marked only luminance
lum(pureLuminance) = radius(pureLuminance);
chro_LM(pureLuminance) = 0;
chro_S(pureLuminance) = 0;

if strcmpi(p.Results.Direction, 'Classic')
    warning(['Argument ''Classic'' puts red left and blue down per original DKL paper. ' ...
        'This is now atypical. Use argument ''Regular'' to use typical standards.'])
else %Not doing elseif, typo means use the regular one
    chro_LM = -chro_LM;
    chro_S = -chro_S;
end

DKLradians = [chro_LM, chro_S, lum];
end

