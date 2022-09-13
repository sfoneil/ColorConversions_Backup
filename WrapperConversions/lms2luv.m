function [Luv, chromaticity] = lms2luv(LMS, varargin)
%LMS2LUV Summary of this function goes here
%   Detailed explanation goes here

%% Get Inputs
p = inputParser;
p.KeepUnmatched = true;
validColorInput = @(x) size(x,2) == 3;
addRequired(p, 'LMS', validColorInput);
parse(p, LMS, varargin{:})
passthru = p.Unmatched;

%% Calculations
XYZ = lms2xyz(LMS, passthru);
[Luv, chromaticity] = xyz2luv(XYZ, passthru);

end

