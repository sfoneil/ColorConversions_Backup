function [RGB, satFlag, unclampedRGB] = xyy2rgb(xyY, varargin)
%XYY2RGB Wrapper for xyY -> XYZ -> LMS -> RGB
%% Parse inputs
% p = inputParser;
% p.KeepUnmatched = true;
% validColorInput = @(x) size(x,2) == 3;
% addRequired(p, 'xyY', validColorInput);
% parse(p, xyY, varargin{:})
% passthru = p.Unmatched;
p = iparse(xyY, varargin{:});

XYZ = xyy2xyz(xyY, varargin{:});
% LMS = xyz2lms(XYZ, varargin{:});
% [RGB, satFlag, unclampedRGB] = lms2rgb(LMS, varargin{:});
[RGB, satFlag, unclampedRGB] = xyz2rgb(XYZ, varargin{:});

end