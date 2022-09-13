function MW = rgb2mw(RGB, varargin)
%RGB2MW Convert display spectral RGB to MW Lab space
%   Wrapper function

%todo not reversible
p = iparse(RGB, varargin{:});
%LMS = rgb2lms(RGB, varargin{:});
XYZ = rgb2xyz(RGB, varargin{:});
LMS = xyz2lms(XYZ, varargin{:});
MB = lms2mb(LMS, varargin{:});
MW = mb2mw(MB, varargin{:});
end