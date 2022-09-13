function XYZ = dkl2xyz(DKL, varargin)
%DKL2XYZ Convert DKL to XYZ-like space
%   Detailed explanation goes here
p = iparse(DKL, varargin{:});

LMS = dkl2lms(DKL, varargin{:});
XYZ = lms2xyz(LMS, varargin{:});
end