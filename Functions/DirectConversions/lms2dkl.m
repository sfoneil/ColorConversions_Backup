function dkl = lms2dkl(Target, varargin)
%LMS2DKL Convert LMS cone activations to DKL Lum, L-M, S-LM coordinates
%   Convenience wrapper function for lms_dkl which computes both directions.
%   dkl = lms_dkl(direction, backgroundColor, targetColor)
%
%   Where:
%       backgroundColor reference color in LMS units, use rgb2lms() first
%       if needed.
%       targetColor is generated in reference to backgroundColor

% colorInfo doesn't do anything yet, for future use
dkl = lms_dkl('lms2dkl', Target, varargin{:});

end

