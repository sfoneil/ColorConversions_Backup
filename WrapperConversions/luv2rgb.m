function [RGB, satFlag, unclampedRGB] = luv2rgb(Luv, varargin)
%LUV2RGB Convert L*u*v* to RGB
%   Wrapper function, uses xyz2rgb(luv2xyz(Luv))

%% Get Inputs

ci = loadCI();

p = inputParser;
p.KeepUnmatched = true;
validColorInput = @(x) size(x,2) == 3;
addRequired(p, 'Luv', validColorInput);
parse(p, Luv, varargin{:})
passthru = p.Unmatched;
% CATvalidator = @(x) any(validatestring(x, validConvs));
% p = inputParser;
% addParameter(p, 'Primaries', 'Default');
% addParameter(p, 'Linearizing', 'sRGB');
% addParameter(p, 'Space', 'Cartesian');
% addParameter(p, 'WhitePoint', 'D65_2');
% addParameter(p, 'CAT', 'ss', CATvalidator);
% addParameter(p, 'Fundamentals', ci.Fundamentals)
parse(p, Luv varargin{:});

%% Calculations

XYZ = luv2xyz(Luv, passthru);

[RGB, satFlag, unclampedRGB] = xyz2rgb(XYZ, passthru);
%todo: make these an option, see why there are differences?
%LMS = xyz2lms(XYZ, 'CAT', p.Results.CAT);
%[RGB, satFlag, unclampedRGB] = lms2rgb(LMS, 'Fundamentals', p.Results.Fundamentals);

end

