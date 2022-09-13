function funcHandle = overloadConversion(funcName, verbose)
%OVERLOADCONVERSION Checks function names that conflict with built-in functions.
%Makes assumption about intended use based on existing variables (e.g.
%colorInfo2).
%   Handled functions include: rgb2hsv() hsv2rgb() rgb2lab() lab2rgb()
%   rgb2xyz() xyz2rgb() xyz2lab() lab2xyz()
% funcName is a string/character vector
% funcHandle is an anonymous function
% Probably not good coding practice, but this is for consistent naming
% scheme, and may not be necessary is path is added correctly to give
% precedence.

% Warn user about which conversion used only if requested
if nargin == 1
    verbose = 1;
end

%% Check if IP Toolbox installed
toolboxName = 'Image Processing Toolbox';
v = ver;
tbExists = any(strcmp(toolboxName, {v.Name}));

if ~tbExists
    %     if verbose
    warning('Image Processing Toolbox not installed, so %s() is assumed to be from the UNR Color Conversion Toolbox.\n', ...
        funcName);
    %     end
    funcHandle = str2func(funcName);
    return
end

% %% Otherwise, get path to toolbox
%
% funcPath = which(funcName);
% if contains(funcPath, MLdir)
%     % Built-in is on path
% else
%     % Not in path
% end

%% Check for colorInfo2 and
try
    [ci, phos] = loadCI();
    %     if verbose
    %         warning('Using UNR Color Conversion toolbox %s() function.', funcName);
    %     end
    switch funcName
        case 'rgb2hsv'
            funcHandle = str2func('rgbTOhsv');
        case 'hsv2rgb'
            funcHandle = str2func('hsvTOrgb');
        case 'rgb2lab'
            funcHandle = str2func('rgbTOlab');
        case 'lab2rgb'
            funcHandle = str2func('labTOrgb');
        case 'rgb2xyz'
            funcHandle = str2func('rgbTOxyz');
        case 'xyz2rgb'
            funcHandle = str2func('xyzTOrgb');
        case 'xyz2lab'
            funcHandle = str2func('xyzTOlab');
        case 'lab2xyz'
            funcHandle = str2func('labTOxyz');
    end


catch ME
    throw(ME)
    if verbose
        warning(sprintf('Using Image Processing toolbox %s() function.', funcName));
    end
    MLdir = matlabroot;

    switch funcName
        case {'rgb2hsv', 'hsv2rgb'}
            tb = '\toolbox\matlab\images\';
        case {'rgb2lab', 'lab2rgb', 'rgb2xyz', 'xyz2rgb', 'xyz2lab', 'lab2xyz'}
            tb = '\toolbox\images\colorspaces\';

            %         case 'rgb2hsv'
            %             tb = '\toolbox\matlab\images\rgb2hsv.m';
            %         case 'hsv2rgb'
            %             tb = '\toolbox\matlab\images\hsv2rgb.m';
            %         case 'rgb2lab'
            %             tb = '\toolbox\images\colorspaces\rgb2lab.m';
            %         case 'lab2rgb'
            %             tb = '\toolbox\images\colorspaces\lab2rgb.m';
            %         case 'rgb2xyz'
            %             tb = '\toolbox\images\colorspaces\rgb2xyz.m';
            %         case 'xyz2rgb'
            %             tb = '\toolbox\images\colorspaces\xyz2rgb.m';
            %         case 'xyz2lab'
            %             tb = '\toolbox\images\colorspaces\xyz2lab.m';
            %         case 'lab2xyz'
            %             tb = '\toolbox\images\colorspaces\lab2xyz.m';
    end
    currDir = pwd;
    cd(strcat(MLdir, tb)); % Temporarily change to base function dir
    funcHandle = str2func(funcName); % Create handle to that specific function
    cd(currDir); % Return to current directory
end

