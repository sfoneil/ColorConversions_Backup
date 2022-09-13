function XYZ = lab2xyz(Lab, varargin)
%LAB2XYZ Summary of this function goes here
%   Detailed explanation goes here

fh = overloadConversion('lab2xyz');

XYZ = feval(fh, Lab, varargin{:});
end

