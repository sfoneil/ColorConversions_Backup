function RGB = hsvTOrgb(HSV, varargin)
%RGB2HSV Convert hue, saturation, value to red, green, blue
%   RGB = hsv2rgb(HSV)
%
%   RGB is in range of [0:1, 0:1, 0:1]. HSV is either in range
%   [0:1, 0:1, 0:1], but may be assumed to be in range [0:359..., 0:1, 0:1]
%   if the hue value is greater than 1.
%   Hue is an angle value where red is near 0°, green is near 120°, and
%   blue is near 240°
%   Saturation represents mixture with white and ranges from 0 (white) to 1
%   (fully saturated).
%   Value represents mixture with black and ranges from 0 (black) to 1
%   (fully chromatic).

% Define output
%todo refine
if nargin == 1
    range360 = false;
elseif nargin == 2
    range360 = varargin;
end


% Assumed hsv range 0:1
% If one value is out of that range, assume all are in 0:255 range
% This may be an incorrect assumption, check requested rgb

% If [?, 0:100, 0:100] then [0:360 0:1 0:1]
%todo fix
if any(HSV(2:3) > 1)
    %hsv(1) = hsv(1) * 360;
    HSV(2:3) = HSV(2:3) / 100;    
elseif all(HSV <= 1)
    HSV(1) = HSV(1) * 360;
    %hsv(2:3) stays
end



% Todo how to assume [0:1 0:100 0:100]?


% % If [0:360, 0:1, 0:1] then [0:360, 0:100, 0:100]
% if all(hsv(2:3) < 1)
%     hsv(2:3) = hsv(2:3) * 100;
% end




% Individual hsv for readability
h = HSV(1);
s = HSV(2);
v = HSV(3);

% % Convert input for calculation
% if isDegree
%     h = h * 360;
%     h = h / 60;
% else
%     h = h / 60;
% end

% Get the chroma
chroma = v * s;

x = chroma * (1 - abs( ...
    mod(h/60, 2) - 1) ...
    );

% Put hue in range
if h >= 360
    h = mod(h,360);
end

if isnan(h) %todo fix
    r = 0; g = 0; b = 0;
elseif (h >= 0) && (h < 60)
    r = chroma; g = x; b = 0;
elseif (h >= 60) && (h < 120)
    r = x; g = chroma; b = 0;
elseif (h >= 120) && (h < 180)
    r = 0; g = chroma; b = x;
elseif (h >= 180) && (h < 240)
    r = 0; g = x; b = chroma;
elseif (h >= 240) && (h < 300)
    r = x; g = 0; b = chroma;
elseif (h >= 300) && (h < 360)
    r = chroma; g = 0; b = x;
end

% Put in range
match = v - chroma;

% Output rgb
RGB = ([r, g, b] + match);
end