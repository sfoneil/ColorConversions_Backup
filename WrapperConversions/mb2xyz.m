function XYZ = mb2xyz(MB, varargin)
%MB2XYZ Summary of this function goes here
%   Detailed explanation goes here
p = inputParser;
p.KeepUnmatched = true;
validMBInput = @(x) size(x,2) == [2 3 4];
addRequired(p, 'MB', validMBInput);
parse(p, MB, varargin{:})
passthru = p.Unmatched;



LMS = mb2lms(MB, passthru);
XYZ = lms2xyz(LMS, passthru);


end

