function LMS = xyy2lms(xyY, varargin)
%XYY2LMS Wrapper for xyY -> XYZ -> LMS

%% Parse inputs
p = inputParser;
p.KeepUnmatched = true;
validColorInput = @(x) size(x,2) == 3;
addRequired(p, 'xyY', validColorInput);
parse(p, xyY, varargin{:})
passthru = p.Unmatched;


XYZ = xyy2xyz(xyY, passthru);
LMS = xyz2lms(XYZ, passthru);

end

