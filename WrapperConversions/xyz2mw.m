function MW = xyz2mw(XYZ, varargin)
%XYZ2MW Convert XYZ-like space to MW
%   Detailed explanation goes here

p = iparse(XYZ, varargin{:});

LMS = xyz2lms(XYZ, varargin{:});
MB = lms2mb(LMS, varargin{:});
MW = mb2mw(MB, varargin{:});


end