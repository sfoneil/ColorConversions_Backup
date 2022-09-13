function LMS = dkl2lms(DKL, varargin)
%DKLTOLMS Convert DKL space to LMS cone activation space.
%   Direct conversion, but uses combined function LMS_DKL for both
%   directions.
%
%   lms = DKL2LMS(lmsBack, dkl) takes two 3x1 vectors:
%       lmsBack [l, m, s] cone activations representing the background
%           stimulus or origin in DKL space
%       dkl [lum, lm, slm] DKL values with origin rescaled to 0

LMS = lms_dkl('dkl2lms', DKL, varargin{:});

end

