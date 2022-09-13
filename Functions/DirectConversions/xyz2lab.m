function Lab = xyz2lab(XYZ, varargin)
%XYZ2LAB Summary of this function goes here
%   Detailed explanation goes here
fh = overloadConversion('xyz2lab');

Lab = feval(fh, XYZ, varargin{:});
end

