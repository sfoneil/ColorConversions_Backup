function Lab = rgbTolab(RGB, varargin)
%RGB2LAB Wrapper function to convert RGB trivalue to DKL
%   Detailed explanation goes here

%LMS = rgb2lms(RGB, varargin{:});
%XYZ = lms2xyz(LMS, varargin{:});

%% Parse inputs
p = inputParser;
p.KeepUnmatched = true;
validColorInput = @(x) size(x,2) == 3;
addRequired(p, 'RGB', validColorInput);
parse(p, RGB, varargin{:})
passthru = p.Unmatched;


%% Calculations
XYZ = rgb2xyz(RGB, passthru);
Lab = xyz2lab(XYZ, passthru);

end