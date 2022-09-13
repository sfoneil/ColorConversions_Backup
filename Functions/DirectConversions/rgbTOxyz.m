function cXYZ = rgbTOxyz(RGB, varargin)
%RGB2XYZ Convert monitor spectrum at specific RGB levels to CIE 1931 XYZ
%   Detailed explanation goes here

ci = loadCI();
p = iparse(RGB, varargin{:});

data = RGB.Value;
luminance = RGB.Luminance; % Need to preserve this
%% Companding
method = p.Results.Lin;
if strcmpi(method, 'sRGB')
    compFunc = @sRGBCompanding;
elseif strcmpi(method, 'Gamma')
    compFunc = @gammaCompanding;
elseif strcmpi(method,'L')
    compFunc = @LCompanding;
elseif strcmpi(method, 'none')
    compFunc = @doNothing; % Do nothing
elseif strcmpi(method, 'LMS')
    % todo Go RGB-->LMS-->XYZ. Readdress later
end
linear = compFunc('Linear', data); % Make linear based on function

%% Get conversion matrices
primaries = p.Results.Primaries;
if strcmpi(primaries, 'Default')
    % Use recorded monitor primaries, colorInfo2
    % WhitePoint = D65_2, may want to specify later?
    xPrimary = ci.CIEx;
    yPrimary = ci.CIEy;
elseif strcmpi(primaries, 'sRGB')
    % Use sRGB display standards
    % WhitePoint = D65_2
    xPrimary = [0.64 0.30 0.15];
    yPrimary = [0.33 0.60 0.06];
elseif strcmpi(primaries,'Apple RGB') || strcmpi(primaries,'AppleRGB')
    % Use Apple RGB
    % WhitePoint = D65_2
    xPrimary = [0.625 0.28 0.155];
    yPrimary = [0.34 0.595 0.07];
elseif strcmpi(primaries, 'Adobe')
    % Use Adobe 1998 RGB
    % WhitePoint = D65_2
    xPrimary = [0.64 0.21 0.15];
    yPrimary = [0.33 0.71 0.06];
else
    error('Undefined RGB primary space. Make a request if you want a new one added.')
end

[RGBtoXYZ] = makeRGB_XYZtransform(xPrimary, yPrimary);

%% Convert

XYZ = (RGBtoXYZ * linear')';

%todo: adapt if same or not?
XYZ = chromaticAdaptation(XYZ, p.Results.FromWP, p.Results.ToWP);

cXYZ = trival({'XYZ', XYZ, luminance});

if p.Results.RestoreLuminance == 1
    cXYZ = restoreLumXYZ(cXYZ);
end

end

