function [guns] = setLum(xyY, varargin)
%SETLUM Adjust guns levels to reproduce a specific x, y chromaticity at
%luminance Y in cd/m^2
%   Resulting cd/m^2 should be gamma corrected

p = inputParser;
addRequired(p, 'xyY', @isnumeric);
% addRequired(p, 'luminance', @isnumeric);
addParameter(p, 'Clamp', 1); % Multiply result by this e.g. 255

parse(p, xyY, varargin{:});

lum = xyY(:,3);
if all(lum <= 1)
    lum = rescaleRange(lum, 100);
end
xyY = [xyY(:,1:2), lum];
    
clamp = p.Results.Clamp;
if isnumeric(clamp)
    mult = clamp;
end

ci = loadCI();
x = ci.CIEx;
y = ci.CIEy;

% Test vals - Kaiser & Boynton
% x = [0.620, 0.291, 0.153];
% y = [0.348, 0.608, 0.079];
% Will return approx.
% R = 2.999 G = 6.105 B = 0.896

z = (1 - x - y); % Calculate z

%% Conversion matrix
% Same as in makeRGB_XYZtransform
mat1 = [x(1)/y(1), x(2)/y(2), x(3)/y(3);
    1, 1, 1;
    z(1)/y(1), z(2)/y(2), z(3)/y(3)];

% Get XYZ
XYZ = xyy2xyz(xyY);

candelasPerGun = (mat1 \ XYZ')';

maxLums = ci.MaxLuminance;
guns = candelasPerGun ./ maxLums .* mult;

% % Code for gamma
% screenNum = 1;
% w = Screen('OpenWindow', screenNum);
% Screen('LoadNormalizedGammaTable', w, gammaTable);
% or to cancel
% Screen('LoadNormalizedGammaTable', w, [linspace(0,1,256); linspace(0,1,256); linspace(0,1,256)]');
% WaitSecs(2);
% sca

end

