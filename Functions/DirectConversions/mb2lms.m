function LMS = mb2lms(MB, varargin)
%Convert MacLeod-Boynton coordinates to LMS cone contrasts

colorInfo2 = loadCI();
p =  iparse(MB, varargin{:});

% MB S&S conversion scalings
MBLIN2deg = [0.689903, 0.348322, 0.0371597];
MBQUANTA2deg = [0.674132, 0.356683, 0.0466886];
%todo put these in
MBLIN10deg = [0.673905, 0.356563, 0.0683483];
MBQUANTA10deg = [0.692839, 0.349676, 0.0554786];

defMBSCALE = MBLIN2deg;

% Make Nx4 if it is not
%MB = checkMB(MB); %OBSOLETE?

%MBSCALE = diag(p.Results.MBScale);
MBSCALE = p.Results.MBScale;

data = MB.Value;

%% Calculations
% Split for readability!
%Todo lum array vs multiple?
%todo 1xN vs Nx1?

lum = MB.Luminance; %MB(:, 4);
%MBnoLum = MB(:, 1:3);

LMS_scaled = data .* abs(lum); % Won't scale if -1 (undefined)

LMS_unscaled = LMS_scaled ./ MBSCALE;

LMS = trival({'LMS', LMS_unscaled, lum});
end