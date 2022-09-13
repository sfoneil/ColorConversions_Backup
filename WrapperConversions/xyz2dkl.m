function DKL = xyz2dkl(XYZ, varargin)
%XYZ2DKL Convert XYZ-like space to DKL
%   Detailed explanation goes here
p = iparse(XYZ, varargin{:});

LMS = xyz2lms(XYZ, varargin{:});
DKL = lms2dkl(LMS, varargin{:});
end

