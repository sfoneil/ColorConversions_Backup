function [rgb, background] = xdkl(dR)
% dR is a desired DKL vector

% The following are chromaticity measurements at
% [0.5 0 0], [0 0.5 0] and [0 0 0.5]
% x = [0.665 0.338 0.145]; % xR xG xB
% y = [0.335 0.642 0.044]; % yR yG yB
% L0 = [30 132 10]';       % YR YG YB

x = [0.6570 0.3077 0.1475];
y = [0.3309 0.6234 0.0580];
 = [25.6100000000000 64.6800000000000 8.18100000000000];

%gamma = [2.1 2 2];        % monitor gamma for r g b guns
gamma = [2.056 2.123 1.932]; % From Curve Fitting tool
Lmin = 0.5; % Y at rgb = [0 0 0]
Lmax = [60.5 264.5 20.5]; % Y at rgb = [1 0 0], [0 1 0]                              % and [0 0 1]
Lmax = [25.6100000000000 64.6800000000000 8.18100000000000];

z = 1 - x - y;            % zR zG zB

% Combine two 3x3 matrix in Eq 5.12
L2P = [0.15516 0.54308 -0.03287;
    -0.15516 0.45692  0.03287;
    0      0       0.01608] * ...
    [x ./ y;          1 1 1;
    z ./ y];
P0 = L2P * L0;              % compute background cone
                            % excitation (Eq 5.12)

% Conversion matrix (3x3) in Eq 5.17
DKL2dP = inv([1 1 1;            ...
    1 -P0(1)/P0(2) 0;         ...
    -1 -1 (P0(1)+P0(2))/P0(3)]);

% In Eq 5.17, set [dRlum dRL_M dRS_lum] to [1 0 0], [0 1 0]
% and [0 0 1] respectively. For each one, solve one of the
% constants k based on CL^2 + CM^2 + CS^2 = 1.
kFactor = sqrt(sum((DKL2dP ./ (P0 * [1 1 1])) .^ 2))';

% Now convert DKL contrast dR (3x1) into normalized rgb
dP = DKL2dP * (dR ./ kFactor); % Eq 5.17
dL = inv(L2P) * dP;            % Eq 5.15
c =  (1 + dL ./ L0) / 2;   % convert to normalized rgb                             
                            % contrast
rgb = ((Lmax + Lmin) ./ (Lmax - Lmin) .* c'  ) ...
    .^ (1 ./ gamma); % Eq 5.3
background = ((Lmax + Lmin) ./ (Lmax - Lmin)  ...
    .*[0.5 0.5 0.5]) .^ (1 ./ gamma);
end