function [RGB, satFlag, unclampedRGB] = xyzTOrgb(XYZ, varargin)
%XYZ2RGB Convert XYZ-type color space to RGB values
%   First converts XYZ to linear RGB using a 3x3 matrix calculated from CIE
%   x,y display primaries, either based on colorInfo2 or a standard. Linear
%   output is then made non-linear using either sRGB standard, monitor
%   gamma, or L*
ci = loadCI();
p = iparse(XYZ, varargin{:});


% theirRGB = [0.0259765452320726	-0.0103412507738756	0.000441605752462332
% -0.0123865643390844	0.0205176007906966	-0.00120504906714381
% -0.00391944337472376	0.000421817178820747	0.00893458131042042];

%todo: adapt if same or not?
data = XYZ.Value;

%% White point parsing
data = chromaticAdaptation(data, p.Results.FromWP, p.Results.ToWP); %todo add from request

%% Get conversion matrices
primaries = p.Results.Primaries;
if strcmpi(primaries, 'Default')
    % Use recorded monitor primaries, colorInfo2
    xPrimary = ci.CIEx;
    yPrimary = ci.CIEy;
elseif strcmpi(primaries, 'sRGB')
    % Use sRGB display standards, space D65_2
    xPrimary = [0.64 0.30 0.15];
    yPrimary = [0.33 0.60 0.06];
elseif strcmpi(primaries,'Apple RGB') || strcmpi(primaries,'AppleRGB') || strcmpi(primaries,'Apple')
    % Use Apple RGB
    xPrimary = [0.625 0.28 0.155];
    yPrimary = [0.34 0.595 0.07];
elseif strcmpi(primaries, 'Adobe')
    % Use Adobe 1998 RGB
    xPrimary = [0.64 0.21 0.15];
    yPrimary = [0.33 0.71 0.06];
else
    error('Undefined RGB primary space. Make a request if you want a new one added.')
end

[~, XYZtoRGB] = makeRGB_XYZtransform(xPrimary, yPrimary, varargin{:});

%% Linearize from matrix
method = p.Results.Lin;
%XYZ = XYZ./100;

% Convert XYZ to linear RGB
%todo generalize this for all functions?

if p.Results.UseCd
    linearRGB = setLum(xyz2xyy(rescaleRange(data,1)));
else
    linearRGB = (XYZtoRGB * rescaleRange(data,1)')';
end

% Method of linearizing
if strcmpi(method, 'sRGB')
    % Use sRGB standard, gamma == 2.2
    compFunc = @sRGBCompanding;
elseif strcmpi(method, 'Gamma')
    % Use gamma from colorInfo2 recorded
    compFunc = @gammaCompanding;
elseif strcmpi(method,'L')
    % L*
    compFunc = @LCompanding;
elseif strcmpi(method,'none')
    % Don't linearize, returns same value as linearRGB
    compFunc = @doNothing;
elseif strcmpi(method, 'LMS')
    compFunc = @(x) lms2rgb(xyz2lms(x));
    % todo Go RGB-->LMS-->XYZ. Readdress later
end

if strcmpi(method,'LMS')
    RGBv = compFunc(data);
else
    RGBv = compFunc('Inverse', linearRGB);
end
RGB = trival({'RGB', RGBv, XYZ.Luminance});
%% Output final RGB values
[RGB, satFlag, unclampedRGB] = checkSaturation(RGB);

end

