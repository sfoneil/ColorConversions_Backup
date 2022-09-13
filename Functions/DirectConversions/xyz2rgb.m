function [RGB, satFlag, unclampedRGB] = xyz2rgb(XYZ, varargin)
%XYZ2RGB Converts from XYZ space to RGB space and gamma-corrects.
%This function locally overloads built-in MATLAB xyz2rgb with xyzTOrgb from
%this toolbox instead.
%   See also: XYZ2SRGB XYZ2LINEARRGB MAKERGB_XYZTRANSFORM
fh = overloadConversion('xyz2rgb');

[RGB, satFlag, unclampedRGB] = feval(fh, XYZ, varargin{:});
end

