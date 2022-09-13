function [cMB] = lms2mb(LMS, varargin)
%LMS2MB Convert LMS cone activation to MacLeod-Boynton color space

%% Parse

% MB S&S conversion scalings
MBLIN2deg = [0.689903, 0.348322, 0.0371597];
MBQUANTA2deg = [0.674132, 0.356683, 0.0466886];
%todo put these in
MBLIN10deg = [0.673905, 0.356563, 0.0683483];
MBQUANTA10deg = [0.692839, 0.349676, 0.0554786];

defMBSCALE = MBLIN2deg;
LMSCALE = 1; % 2 Or 1.63
p = iparse(LMS, varargin{:});
data = LMS.Value;

MBSCALE = diag(p.Results.MBScale');

% Rescale to luminance = 2*(L+M), S normalized to max = 1
LMSscaled = (MBSCALE * data')';

% Need DKL 

% Denominator, for cleaner code
lum = LMSscaled(:,1) + LMSscaled(:,2);
%todo add check with saved lum?


% Calculate MB numbers
mbL = LMSscaled(:,1) ./ lum;
mbM = LMSscaled(:,2) ./ lum;
mbS = LMSscaled(:,3) ./ lum;


% lum = (LMSCALE * LMSscaled(:,1)) + LMSscaled(:,2);

%mbM = Lum - (LMSCALE * LMSscaled(1));

cMB = trival({'MB', [mbL mbM mbS], LMS.Luminance});

end

