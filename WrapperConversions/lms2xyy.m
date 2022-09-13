function xyY = lms2xyy(LMS, varargin)
%LMS2XYY Wrapper for LMS -> XYZ -> xyY

% Parse inputs
p = inputParser;
p.KeepUnmatched = true;
validColorInput = @(x) size(x,2) == 3;
addRequired(p, 'LMS', validColorInput);
parse(p, LMS, varargin{:})
passthru = p.Unmatched;

%% Calculations
XYZ = lms2xyz(LMS, passthru);
xyY = xyz2xyy(XYZ, passthru);
end

