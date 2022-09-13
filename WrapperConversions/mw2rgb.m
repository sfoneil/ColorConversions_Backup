function [RGB, satFlag, unclampedRGB] = mw2rgb(MW, varargin)
%MW2RGB Summary of this function goes here
%   MW is Nx3 (L-M, S-L+M, L+M or luminance)


%[ci, phos] = loadCI();
p = iparse(MW, varargin{:});

MB = mw2mb(MW, varargin{:});
[LMS] = mb2lms(MB, varargin{:});
% [RGB, satFlag, unclampedRGB] = lms2rgb(LMS, varargin{:});
% 
% warning('fix me')
% unclampedRGB = gammaCompanding('inverse', unclampedRGB);

XYZ = lms2xyz(LMS, varargin{:});
[RGB, satFlag, unclampedRGB] = xyz2rgb(XYZ, varargin{:});
%[RGB, satFlag] = lms2rgb(LMS);

end

