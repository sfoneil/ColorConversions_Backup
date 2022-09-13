function LMS = mw2lms(MW, varargin)
%MW2LMS Summary of this function goes here
%   Detailed explanation goes here

% Constant
MBSCALE = [0.689903, 0.348322, 0.0371597];

% Parse
p = inputParser;
addRequired(p, 'MW', @isnumeric);
%addRequired(p, 'lum', @isnumeric);
addParameter(p, 'MBScale', MBSCALE, @isnumeric);
parse(p, MW, varargin{:});
scalingFactor = p.Results.MBScale;

lum = MW(:,3);
MB = mw2mb(MW);
LMS = mb2lms(MB, lum, 'MBScale', scalingFactor);
end

