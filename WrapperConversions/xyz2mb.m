function [MB, lum] = xyz2mb(XYZ, varargin)
%XYZ2MB Convert XYZ-like space to MacLeod-Boynton
%   Detailed explanation goes here


%% Parse inputs
p = iparse(XYZ, varargin{:});


LMS = xyz2lms(XYZ, varargin{:});
[MB] = lms2mb(LMS, varargin{:});
end