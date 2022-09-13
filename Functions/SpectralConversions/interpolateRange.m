function newRange = interpolateRange(inRange, varargin)
%interpolate_range Interpolate a m x 4 array, where column 1 == wavelengths
%and column 2:4 == R, G, B gun outputs.
%
%   newRange = interpolate_range(inRange) takes a coarse-stepped inRange,
%   changes it to 1 nanometer steps, and interpolates the R, G, B
%   accordingly. This harmonizes different step sizes for comparison in
%   color conversions
%
%   Coarse steps include:
%   4 nm: output of Photo Research PR-655 output.
%   5 nm: other sources, including Stockman & Sharpe fundamentals
%   10 nm: X-Rite i1 Pro output
%
%   See also INTERPOLATESPRAGUE, TRUNCRANGE. This function should be run on two ranges after both
%   have been truncated

%Todo: if end point is not large enough, ends early???
%Get interpolated wavelength list

p = inputParser;
addParameter(p, 'StepSize', 1);
addParameter(p, 'StartWL', inRange(1, 1));
addParameter(p, 'EndWL', inRange(end, 1));
%Todo: FIX ENDPOINT PROBLEMS
parse(p, varargin{:});
ss = p.Results.StepSize;
sWL = p.Results.StartWL;
eWL = p.Results.EndWL;

%fullRange = [inRange(1,1):inRange(end,1)]';
fullRange = [sWL:ss:eWL]';

%Interpolate to 1 nm steps.
%fineY = interp1(coarseX, coarseY, fineY);
%ys = interp1(inRange(:,1), inRange(:,2:4), fullRange, 'spline');
ys = fullRange;
ys(:,2) = interp1(inRange(:,1), inRange(:,2), fullRange);
ys(:,3) = interp1(inRange(:,1), inRange(:,3), fullRange);
ys(:,4) = interp1(inRange(:,1), inRange(:,4), fullRange);


% LMSspectra = RGBspectra(:,1);
% LMSspectra(:,2) = spline(LMS5nm(:,1),LMS5nm(:,2),LMSspectra(:,1));
% LMSspectra(:,3) = spline(LMS5nm(:,1),LMS5nm(:,3),LMSspectra(:,1));
% LMSspectra(:,4) = spline(LMS5nm(:,1),LMS5nm(:,4),LMSspectra(:,1));

newRange = ys;
end

