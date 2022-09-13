function XYZ = mw2xyz(MW, varargin)
%MW2XYZ Summary of this function goes here
%   Detailed explanation goes here
% p = inputParser;
% p.KeepUnmatched = true;
% validColorInput = @(x) size(x,2) == 3;
% addRequired(p, 'MW', validColorInput);
% parse(p, MW, varargin{:})
% passthru = p.Unmatched;

p = iparse(MW, varargin{:});

MB = mw2mb(MW, varargin{:});
LMS = mb2lms(MB, varargin{:});
XYZ = lms2xyz(LMS, varargin{:});
end

