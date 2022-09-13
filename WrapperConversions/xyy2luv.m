function [Luv, uv] = xyy2luv(xyY, varargin)
%XYY2LUV Summary of this function goes here
%   Detailed explanation goes here
p = iparse(varargin{:});

XYZ = xyy2xyz(xyY, varargin{:});
[Luv, uv] = xyz2luv(XYZ, varargin{:});
end

