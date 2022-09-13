function XYZ = rgb2xyz(RGB, varargin)
%RGB2XYZ Convert RGB to XYZ
%   Detailed explanation goes here
% Use 'open rgbTOxyz'
fh = overloadConversion('rgb2xyz');

XYZ = feval(fh, RGB, varargin{:});
end

