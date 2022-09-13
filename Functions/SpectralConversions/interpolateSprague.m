function interpolatedSpectrum = interpolateSprague(inSpectrum, varargin)
%INTERPOLATESPRAGUE Interpolation using the %method of T.B. Sprague (1880),
%as approved by CIE Pub No. 167 (2005) for spectral interpolation.
%
%   Constructs a fifth-order polynomial with interpolation of a point P based
%   on the two preceeding points P-1 and P-2 and the succeeding points
%   P+1 and P+2. For start and end points, it extrapolates 2 points at each
%   extreme.
%   It is similar to a Lagrange polynomial but operates piecewise with a
%   moving window across points.
%
%   interpolatedSpectrum = interpolateSprague(inSpectrum), where inSpectrum
%   is number of samples x N>=2 columns. First column is equally-spaced
%   wavelength spectral values, each subsequent column is a sample.
%
%   interpolatedSpectrum = interpolateSprague(inSpectrum, SeparateY), where
%   inSpectrum is the Nx1 x values and SeparateY is NxM number of M spectra.
%
%   See:
%   1) De Kerf, J.L.F. (1975). The interpolation method of Sprague-Karup.
%   J. Computational and Applied Mathematrics 1(2).
%   2) Westland, Interpolation of Spectal Data, in: Encyclopedia of Color
%   Science and Technology (2019).


%% Parse inputs
validSpectrum = @(x) isnumeric(x) && length(x)>=6;
p = inputParser;
addRequired(p, 'inSpectrum', validSpectrum); % Must have at least 6 items
addOptional(p, 'SeparateY', [], validSpectrum);
%addParameter(p, 'multiplier', -1, @isscalar);
%addParameter(p, 'Extrapolate', 0);
parse(p, inSpectrum, varargin{:});

%% Checks
% Get size, assumes more samples than spectra
[nSpectra, nSamples] = size(inSpectrum);
if nSamples > nSpectra
% Do nothing    
    %nSamples = nSamples;
elseif nSpectra > nSamples
    % Transpose for ease of calculation syntax
    inSpectrum = inSpectrum';
    temp = nSamples;
    nSamples = nSpectra;
    nSpectra = temp;
else
    error('Invalid or unresolved spectral input. Should be equally spaced input rows and 1 or more columns.')
end

if isempty(p.Results.SeparateY)
    % x and y supplied together
    x = inSpectrum(1,:);
    y = inSpectrum(2:end,:);
    nSpectra = nSpectra - 1;
else
    x = inSpectrum;
    y = p.Results.SeparateY;
end
% Initialize interpolated x
xx = x(1):1:x(end);
% x = inSpectrum(1, :); % Gapped numbers
% xx = x(1):1:x(end); % Continuous numbers
% 
% y = inSpectrum(2:end, :); %todo all y at once?

% Check wavelength spacing
[b, spacing] = isEquallySpaced(x'); % Transposed
if ~b
    warning('Wavelength spacing appears to be uneven. Verify that it is correct and there are no trailing decimals.')
end


% Check multiplier
% if multiplier == -1
%     multiplier = spacing;
% elseif multiplier == 1
%     % Do nothing
%     return
% end

%% Calculate extrapolated points
% Matrix of constants for extreme points
% Each row == new points [1-2; 1-1; N+1; N+2]
% Each col == old points [1:6; 1:6; N-5:N; N-5:N]
pointConsts = [884 -1960 3033 -2648 1080 -180; ...
    508 -540 488 -367 144 -24; ...
    -24 144 -367 488 -540 508; ...
    -180 1080 -2648 3033 -1960 884];
pointDenom = 209;

% Preallocate spectra with new extrapolated values
expandedOriginalY = zeros(nSpectra, nSamples+4);
for s = 1:nSpectra
    %todo vectorize?
    % 4x6 matrix, first 6 points twice; last 6 points twice
    basePoints = [repmat(y(s,1:6),2,1); repmat(y(s,end-5:end),2,1)];
    newPoints = sum((pointConsts .* basePoints),2) ./ pointDenom;
    % Spectrum with all points, size(fullSpectrum,2) == size(inSpectrum,2)+4
    expandedOriginalY(s,:) = [newPoints(1:2)', y(s,:), newPoints(3:4)'];
end



%% Calculate polynomial coefficients
% Constants 6x6
% Each row == coefficients [a0; a1; a2; a3; a4; a5]
% Each col == points [i-2 i-1 i i+1 i+2 i+3]
% coefConsts = [0 0 1 0 0 0;
%     2 -16 0 16 -2 0;
%     -1 -16 -30 16 -1 0;
%     -9 39 70 66 -33 7;
%     13 -64 126 -124 61 -12;
%     -5 25 -50 50 -25 5];

%Todo check, sources contradict on the 2 decimaled values, flipped sign?
coefConsts = [0 0 1 0 0 0;
    2 -16 0 16 -2 0;
    -1 16.0 -30 16 -1 0;
    -9 39 -70.0 66 -33 7;
    13 -64 126 -124 61 -12;
    -5 25 -50 50 -25 5];
coefDenom = [1 24 24 24 24 24]'; % Divisor

%b = bsxfun(@times, )
%coefConsts = struct();
% coefConsts{1} = [0 0 1 0 0 0];
% coefConsts{2} = [2 -16 0 16 -2 0];
% coefConsts{3} = [-1 16.0 -30 16 -1 0];
% coefConsts{4} = [-9 39 -70.0 66 -33 7];
% coefConsts{5} = [13 -64 126 -124 61 -12];
% coefConsts{6} = [-5 25 -50 50 -25 5];

% Create Nx6 sliding window of indices to apply coefs
idxMat = [-2 -1 0 1 2 3] + (3:size(expandedOriginalY, 2) - 3)';
interpProportions = 1/spacing:1/spacing:1-1/spacing; % Proportion for intermediate points
%vals = expandedOriginalY(s, idxMat(i,:))';


yy = zeros(nSpectra, size(xx,2)); % Init
for s = 1:nSpectra
    vals = reshape(expandedOriginalY(s, idxMat(:)),[],6)';
    aCoefsForPoint = coefConsts * vals;
    aCoefsForPoint = fliplr((aCoefsForPoint ./ coefDenom)'); % Ascending order now
    for  i = 1:nSamples-1 % Loop thru ungapped original values
       
       
        % Now we want to multply each line of vals with all 6 coefficient lines.
  
        interpolatedValues = polyval(aCoefsForPoint(i,:), interpProportions); % Calc values between known values
        baseIdx = (i-1)*spacing+1; % Determine indicies provided with known y
        yy(s, baseIdx) = y(s, i); % Put known values into expanded array, rest remain zeros
        yy(s, baseIdx+1:baseIdx+(spacing-1)) = interpolatedValues; % Useing the spacing determined, fill next empty values
    end
    yy(s, end) = y(s, end); % Add in last value
end

% Combine and reuturn
interpolatedSpectrum = [xx;yy]';