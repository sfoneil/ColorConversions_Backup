function [RGB, satFlag, unclampedRGB] = labTOrgb(Lab, varargin)
%LAB2RGB Convert Lab space to RGB
%   Detailed explanation goes here

%% Get Inputs
%p = iparse(Lab, varargin{:});
% p = inputParser;
% p.KeepUnmatched = true;
% validColorInput = @(x) size(x,2) == 3;
% addRequired(p, 'Lab', validColorInput);
% parse(p, Lab, varargin{:})
% passthru = p.Unmatched;

%% Convert
XYZ = lab2xyz(Lab, varargin{:});
[RGB, satFlag, unclampedRGB] = xyz2rgb(XYZ, varargin{:});
% LMS = xyz2lms(XYZ, varargin{:});
% RGB = lms2rgb(LMS, varargin{:});

% [RGB, satFlag] = checkSaturation(RGB);

end

