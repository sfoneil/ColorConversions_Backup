function wpTrival = loadWhitePoint(WPStr, varargin)
%LOADWHITEPOINT Load white point trivalue from structure in .MAT file.
%   wp = loadWhitePoint('d65_2')
%       Loads saved D65 for 2-degree observer in XYZ
%   wp = loadWhitePoint([0.9642 1.0 0.8252])
%       Loads custom white point (this one is equivalent to D50/2-degree
%   wp = loadWhitePoint('c_64', 'ToSpace', 'uv')
%       Loads illuminant C/10-degree observer, converts to u' v'
%       coordinates

%todo: does this ever need to take Nx vectors?

% Validators
wpValidator = @(x) ischar(x) || isstring(x) || isnumeric(x); %|| isempty(x)
spaceValidator = @(x) ischar(x) || isstring(x);

% Start parsing string inputs or custom
p = inputParser;
addRequired(p, 'WPStr', wpValidator);
addParameter(p, 'ToSpace', 'XYZ', spaceValidator);
parse(p, WPStr, varargin{:});

% Use custom WP, or load based on string
inputWP = upper(p.Results.WPStr);
wpUnconverted = [];
if isnumeric(inputWP)
    % Use custom white point. It is assumed to be XYZ, and program does not
    % know if you use a custom number that is not XYZ
    inputWP = inputWP(:)'; % Force to row vector
    if size(inputWP,2) == 3
        wpUnconverted = inputWP;
    elseif size(inputWP,2) == 2
        wpUnconverted = [inputWP(1), 1, inputWP(2)]; % Have to assume Y?
%     if size(inputWP, 1) == 3
%         wpUnconverted = inputWP';
%     elseif size(inputWP, 2) == 3
%         wpUnconverted = inputWP;
%     elseif size(inputWP,1) == 2
%         wpUnconverted = inputWP';
%         wpUnconverted = 
%     elseif size(inputWP,2) == 2

    else
        error('White Point not valid. Verify it is Nx3 or a character array.')
    end

elseif ischar(inputWP) || isstring(inputWP)
    load illuminants.mat
    wpUnconverted = eval(strcat('si.', inputWP));
    clearvars si % Remove from memory
end

switch lower(p.Results.ToSpace)
    case 'xyz'
        wpTrival = wpUnconverted;% .*100; %todo check
    case {'xy', 'xyy'}
        wpTrival = xyz2xyy(wpUnconverted);
    case {'luv', 'uv'}
        wpTrival = xyz2luv(wpUnconverted);
    case {'lab', 'ab'}
        wpTrival = xyz2lab(wpUnconverted);
    case {'mb'}
        wpTrival = xyz2mb(wpUnconverted);
    case {'mw'}
        wpTrival = xyz2mw(wpUnconverted);
    otherwise
        error('Unknown conversion of white point.')
end

end