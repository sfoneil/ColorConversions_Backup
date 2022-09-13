function [RGB, satFlag, RGBoriginal] = dkl2rgb(DKL, varargin)
%DKL2RGB Convert DKL space to monitor RGB values
%   Wrapper function for RGB2LMS(background RGB values),
%   DKL2LMS(DKL values, itself a wrapper), and LMS2RGB(resulting LMS)
%Usage:
%
%


%[ci, phos] = loadCI();

%% Get Inputs
p = iparse(DKL, varargin{:});

%% Calculations
bkgdRGB = p.Results.Background;
bkgdLMS = rgb2lms(bkgdRGB); % First need LMS of background
LMS = dkl2lms(DKL, 'Background', bkgdLMS, varargin{:});
%XYZ = lms2xyz(LMS, varargin{:});
[RGB, satFlag, RGBoriginal] = lms2rgb(LMS, varargin{:});
%[a,b,c] = xyz2rgb(XYZ, varargin{:});

end

