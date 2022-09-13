function HSV = rgb2hsv(RGB, varargin)
%RGB2HSV Convert RGB to HSV
%   Detailed explanation goes here

fh = overloadConversion('rgb2hsv');

HSV = feval(fh, RGB, varargin{:});
end

