function [RGBtoXYZ, XYZtoRGB] = makeXYZ_RGBtransform(x, y, varargin)
%MAKEXYZ_RGBTRANSFORM Alias for makeRGB_XYZtransform
%   Detailed explanation goes here
[RGBtoXYZ, XYZtoRGB] = makeRGB_XYZtransform(x, y, varargin{:});
end

