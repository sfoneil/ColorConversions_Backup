function [sRGB, satFlag] = xyz2srgb(XYZ, varargin)
%XYZ2SRGB Convert XYZ to sRGB. Output is standardized, i.e. same on every
%display and does not use fundamentals or phosphors except by applying a
%lookup table after.

%% Parse
wpValidator = @(x) ischar(x) || isstring(x) || isempty(x) || isnumeric(x);
defaultWP = 'd65_2';

p = inputParser;
addRequired(p, 'XYZ', @isnumeric);
addParameter(p, 'WhitePoint', defaultWP, wpValidator);
parse(p, XYZ, varargin{:});

% sRGB chromaticities
chromaticityX = [0.6400, 0.3000, 0.1500];
chromaticityY = [0.3300, 0.6000, 0.0600];
%chromaticityLum = [0.2126 0.7152 0.0722];

% % Load white point
% wpXYZ = loadWhitePoint(p.Results.WhitePoint);
% wpXYY = xyz2xyy(wpXYZ);

[RGBtoXYZ, XYZtoRGB] = makeRGB_XYZtransform(chromaticityX, chromaticityY, varargin{:});

% % For D65 2 degree, should be close to:
% convMat = [3.2406, -1.5372, -0.4986;
%     -0.9689, 1.8758, 0.0415;
%     0.0557, -0.2040, 1.0570];

% todo allow these
% Bradford addapted per BL
% Develop chromaticAdaptation.m
convMatD50 = [3.1338561, -1.6168667, -0.4906146;
-0.9787684, 1.9161415, 0.0334540;
 0.0719453, -0.2289914, 1.4052427];

CUTOFF = 0.0031308;

% nConvs = size(XYZ,1); % Fix later, get number of XYZs
% rgbT = zeros(size(XYZ));

%XYZscaled = XYZ ./ XYZ(:,2); % Scale to 1

rgbT = (XYZtoRGB * XYZ')'; %fix later, asssume 1

[rgbT, satFlag] = checkSaturation(rgbT);

idxLow = rgbT <= CUTOFF;
rgbT(idxLow) = rgbT(idxLow) * 12.92;
rgbT(~idxLow)= 1.055 * rgbT(~idxLow) .^ (1/2.4) - 0.055;



% We want to optionally flag values that are out of gamut, i.e. <0, >1 or
% both.
% But sometimes RGB is some very tiny -value which messes up flag, so we
% need to account for that.
%
% Fix and test extensively!

% CONSTANTS to round very small values near zero to zero. These values are
% tested at 8 bits (1/256) but potentially up to 16-bits (1/65536)
PRECISION = 1 / 2^16; %todo VERIFY LOTS
SIGFIG = 5;

% %todo vectorize
% for i = 1:size(rgbT,1)
%     for c = 1:3
%         if (rgbT(i, c) < PRECISION) && (rgbT(i, c) > -PRECISION)
%             round(rgbT(i, c), SIGFIG);
%     end
% end





% if (any(rgbT) < PRECISION) || (any(rgbT) > -PRECISION)
%     round(rgbT, SIGFIG) %Should be sufficient for 16-bits
% end

% Return RGB value, satFlag is zero if in gamut, 1-3 if out of gamut and
% appropriate measures in your code should be taken.
% Returns satFlag
% [sRGB, satFlag] = checkSaturation(rgbT);
sRGB = rgbT;
end

