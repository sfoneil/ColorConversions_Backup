function [RGBRescaled, satFlag, RGBoriginal] = checkSaturation(RGB, threshold)
%CHECKGAMUT Checks RGB conversions for out-of-gamut errors
%   [rgbRescaled, satFlag = CHECKGAMUT(rgb) takes 3x1 vector with
%   [R G B] values in range of 0:1. If all values are in range, rgbRescaled
%   is identical to rgb. Otherwise, values over 1 have been lowered to
%   1 and values under 0 raised to 0.
%   Variable setFlag is set to 0 if rgb was in range, 1 if > 1,  -1 if < 0,
%   0.5 if > 1 but within a threshold, and -0.5 if < 0 but within the same
%   threshold.
%   
%   Use for individual experiments or visualizations should have code that
%   makes note of the flag status and responds accordingly - whether to
%   display rgbRescaled as given, cause a visual or auditory error or warning, 
%   increase staircase reversals, etc.
%
%   Examples:
%       rgb = [0.9 0 0.4]
%       [rgbRescaled, satFlag] = checkSaturation(rgb)
%     % rgbRescaled == rgb, satFlag = 0
%
%       rgb = [0 0 1.5]
%       [rgbRescaled, satFlag] = checkSaturation(rgb)
%     % rgbRescaled == [0 0 1], satFlag = 1
%
%       rgb = [-1.3 -0.01 1]
%       [rgbRescaled, satFlag] = checkSaturation(rgb)
%     % rgbRescaled == [0 0 1], satFlag = 2
%
%       rgb = [1.2 -0.01 0.5]
%       [rgbRescaled, satFlag] = checkSaturation(rgb)
%     % rgbRescaled == [1 0 0.5], satFlag = 3

% if isa(RGB, 'trival')
    data = RGB.Value;
% else
%     data = RGB;
% end
% Set initial flag state, keept FALSE if in range
if size(data,2) ~= 3
    error('RGB should be in Nx3 format.')
end

satFlag = zeros(size(data));
RGBoriginal = data;

% Values very close to zero can be flagged, avoid this
if nargin == 1
    threshold = 1e-5;
end

% Masks
over = data > 1;
under = data < 0;
overThreshold = data - threshold > 1;
underThreshold = data + threshold < 0;

% Set saturations
satFlag(over) = 1;
satFlag(under) = -1;
satFlag(xor(over, overThreshold)) = 0.5;
satFlag(xor(under, underThreshold)) = -0.5;

% Set to saturated values
data(over) = 1;
data(under) = 0;

% for i = 1:size(RGB,1)
%     for c = 1:3
%         if RGB(i,c) > 1
%             RGB(i,c) = 1;
%             satFlag(i,c) = satFlag(i,c) + 1;
%         end
%         if RGB(i,c) < 0
%             RGB(i,c) = 0;
%             satFlag(i,c) = satFlag(i,c) + 2;
%         end
%         % ifs not nested = flag is 3 if both true
%     end
% end
    
% if any(RGB(:) > 1) && any(RGB(:) < 0)
%     satFlag = 3;
%     RGB(RGB > 1) = 1;
%     RGB(RGB < 0) = 0;
% elseif any(RGB(:) > 1)
%     satFlag = 1;
%     RGB(RGB > 1) = 1;
% elseif any(RGB(:) < 0)
%     satFlag = 2;
%     RGB(RGB < 0) = 0;
% end

% Output final value
RGBoriginal = trival({'RGB', RGBoriginal, RGB.Luminance});
RGBRescaled = trival({'RGB', data, RGB.Luminance});

%todo maybe: allow inputs to do different behavior besides set to min/max?
end