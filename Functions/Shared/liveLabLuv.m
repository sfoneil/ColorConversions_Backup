function [anonConv, wp] = liveLabLuv(fromFunc, XYZLuvLab, varargin)%(to_from, varargin)
%LIVELABLUV
%   Parses Lab, Luv optional inputs such as white point and whether
%   output should be Cartesian or cylindrical. Included for simplified
%   code, only called by XYZ<>Luv and XYZ<>Lab functions and their
%   wrappers. Function also provides generic home decor.
%   fromFunc: character string in format 'xyz2luv' 'luv2xyz' 'xyz2lab' or
%   'lab2xyz'
%   XYZLuvLab: 3x1 XYZ values

%todo, non-d65 not working?


%% Get function that brought you here before parse, one of:
%   luv2xyz() xyz2luv() lab2xyz() xyz2lab())
%fromFunc = args(end); % Pull cell from args
%%fromFunc = funcStr{end}; % Load as char array
%fromFunc = args{1}; % Get contents of cell, a char array
%fromFunc = func2str(fromFunc); % As string

% Remove sending function from args so parse works correctly
%%funcStr(end) = [];


%% Defaults
%d65def = [0.95047 1 1.08883]; % Define default white point: 2 degree D65

defaultWP = 'D65_2';
defaultConversion = 'Cartesian';
wpValidator = @(x) ischar(x) || isstring(x) || isempty(x) || isnumeric(x);
convValidator = @(x) ischar(x) || isempty(x);
%convert = @(x) x.*1;
funcValidator = @(x) ischar(x) || isempty(x);
%% Parse
p = inputParser; % Minus sending function
p.KeepUnmatched = true;
% Define possible inputs
%todo error check
%addRequired(p, s76); % Need Lab or Luv
% addParameter(p, 'WhitePoint', d65def);
% addParameter(p, 'Space', 'Cartesian');

addRequired(p, 'fromFunc', funcValidator);
addRequired(p, 'XYZLuvLab', @isnumeric)
addParameter(p, 'WhitePoint', defaultWP, wpValidator);
addParameter(p, 'Space', defaultConversion, convValidator);
parse(p, fromFunc, XYZLuvLab, varargin{:});

% Get whitepoint vector from illuminants struct
wpInput = p.Results.WhitePoint;
wp = loadWhitePoint(wpInput);
% wpShort = p.Results.WhitePoint;
% if ischar(wpShort) || isstring(wpShort)
%     load illuminants.mat % Load illuminants struct
%     wp = eval(strcat('si.', wpShort));
%     clearvars si % Remove from memory
% elseif isnumeric(wpShort)
%     if size(wpShort, 1) == 3
%         wp = wpShort';
%     elseif size(wpShort, 2) == 3
%         wp = wpShort;
%     else
%         error('White Point not valid. Verify it is Nx3 or a character array.')
%     end
% end
% wp = wp * 100; % Careful: todo verify this is needed?

%% Convert shortcut
% space = p.Results.Space;
% if any(strcmpi(space, {'Cartesian', 'cart'}))
%     space = 'Cartesian';
% elseif any(strcmpi(space, {'Cylindrical', 'cyl'}))
%     space = 'Cylindrical';
% end

% Short form of conversion string to integer 1==Cart 2==Cyl
if any(strcmpi(p.Results.Space, {'Cartesian', 'Cart'}))
    intSpace = 1;
elseif any(strcmpi(p.Results.Space, {'Cylindrical', 'Cyl'}))
    intSpace = 2;
else
    intSpace = -1;
    error('Lab/Luv space not defined correctly.')
end


% if any(strcmpi(wp, {'WhitePoint', 'wp'}))
%      wp =

% Short forms
% wp = p.Results.WhitePoint; % Just pass it along
% sp = p.Results.Space;


%% Create proper function
% switch fromFunc
%     case 'xyz2luv'
%     case 'luv2xyz'
%     case 'xyz2lab'
%     case 'lab2xyz'
% end

% if any(strcmpi(fromFunc, {'xyz2luv', 'xyz2lab'}))
%     if any(strcmpi(sp, {'Cylindrical', 'cyn'))
%         cart_cyl = @(x) toCylindrical(x);
%     else
%         cart_cyl = @(x) x*1; % Do nothing
%     end
% else

% Define initial state, may be overridden
%convert = @(x) x.*1;

% Change functions as needed
anonConv = {};

% Convert first if cylindrical
if intSpace == 2
    switch fromFunc
        case {'luv2xyz', 'lab2xyz'}
            anonConv = @(x) fromCylindrical(x);
        case {'xyz2luv', 'xyz2lab'}
            anonConv = @(x) toCylindrical(x);
    end
else
    anonConv = @(x) x.*1; % Do nothing
end

end