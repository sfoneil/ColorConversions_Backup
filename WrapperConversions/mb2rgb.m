function RGB = mb2rgb(MB, varargin)
%MB2RGB Wrapper for MB --> LMS --> RGB
%   Detailed explanation goes here

% p = inputParser;
% p.KeepUnmatched = true;
validMBInput = @(x) any(size(x,2) == [2 3 4]);
% addRequired(p, 'MB', validMBInput);
% parse(p, MB, varargin{:})
% passthru = p.Unmatched;
LMS = mb2lms(MB, varargin{:});
RGB = lms2rgb(LMS, varargin{:});
% LMS = mb2lms(MB, passthru);
% RGB = lms2rgb(LMS, passthru);
end

