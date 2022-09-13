function HSV = rgbTOhsv(RGB, varargin)
%RGB2HSV Convert red, green, blue to hue, saturation, value
%   HSV = rgb2hsv(RGB)
%
%   RGB is in range of [0:1, 0:1, 0:1]. HSV is either in range
%   [0:1, 0:1, 0:1], but may be assumed to be in range [0:359..., 0:1, 0:1]
%   if the hue value is greater than 1.
%   Hue is an angle value where red is near 0°, green is near 0.333 or 120°,
%   and blue is near 0.667 or 240°
%   Saturation represents mixture with white and ranges from 0 (white) to 1
%   (fully saturated).
%   Value represents mixture with black and ranges from 0 (black) to 1
%   (fully chromatic).

% Define output
%todo refine
if nargin == 1
    longRange = false;
elseif nargin == 2
    longRange = cell2mat(varargin);
end

% Rescale values to assumed rgb range 0:1
% If one value is out of that range, assume all are in 0:255 range
% This may be an incorrect assumption, check requested rgb
if any(RGB > 1)
    RGB = RGB / 255;
end

% Individual rgb for readability
r = RGB(1);
g = RGB(2);
b = RGB(3);

% Get initial values
cmax = max(RGB);
cmin = min(RGB);

% Get the chroma (range)
chroma = cmax - cmin;

% % Get the lightness (middle of range)
% l = (value + xmin) / 2;

% Get hue
if chroma == 0
    hue = 0;
elseif cmax == r
    hue = 60 * ((g - b) / chroma) + 360;
elseif cmax == g
    hue = 60 * ((b - r) / chroma) + 120;
elseif cmax == b
    hue = 60 * ((r - g) / chroma) + 240;
end

% Get hue in range
hue = mod(hue, 360);

% Get saturation
if cmax == 0
    saturation = 0;
else
    saturation = (chroma / cmax) * 100;
end

% Get value
value = cmax * 100;

% % Get saturation
% if l == 0 || l == 1
%     saturation = 0; 
% else
%     saturation = chroma / (1 - abs(2 * value - chroma - 1));
% end

% Convert output
if ~longRange
    hue = hue / 360;
    saturation = saturation / 100;
    value = value / 100;
end

HSV = [hue saturation value];
end

