function xyY = rgb2xyy(RGB, varargin)
%RGB2XYY Wrapper for RGB -> LMS -> XYZ -> xyY


%[colorInfo, phos] = loadCI();
%% Parse inputs
p = inputParser;
p.KeepUnmatched = true;
validColorInput = @(x) size(x,2) == 3;
addRequired(p, 'RGB', validColorInput);
parse(p, RGB, varargin{:})
passthru = p.Unmatched;

LMS = rgb2lms(RGB, passthru);
XYZ = lms2xyz(LMS, passthru);
xyY = xyz2xyy(XYZ, passthru);

end

