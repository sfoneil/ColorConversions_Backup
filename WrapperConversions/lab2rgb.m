function [RGB, satFlag, unclampedRGB] = lab2rgb(Lab, varargin)
%LAB2RGB Convert Lab to RGB
%   Detailed explanation goes here

fh = overloadConversion('lab2rgb');

[RGB, satFlag, unclampedRGB] = feval(fh,Lab, varargin{:});
end

