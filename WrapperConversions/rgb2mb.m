function MB = rgb2mb(RGB, varargin)
%RGB2MB Summary of this function goes here
%   Detailed explanation goes here
%[colorInfo2, phos] = loadCI();
%% Parse inputs
p = inputParser;
p.KeepUnmatched = true;
validColorInput = @(x) size(x,2) == 3;
addRequired(p, 'RGB', validColorInput);
parse(p, RGB, varargin{:})
passthru = p.Unmatched;

LMS = rgb2lms(RGB, varargin{:});
MB = lms2mb(LMS, varargin{:});
end

