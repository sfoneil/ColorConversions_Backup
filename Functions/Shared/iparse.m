function inputParserObject = iparse(data, varargin)
%IPARSE Shared function for returning inputParser object containing given
%arguments


%% Start parser with options
p = inputParser;
p.KeepUnmatched = true; % Mandatory to accept any value

%% Get function name that sent you here
funcs = dbstack;
p.FunctionName = funcs(2).name;
% Allow for 
if strcmpi(p.FunctionName, 'makeXYZ_LMStransform')
    data = NaN;
end
%% Create default options file
% Code to build structure of arguments. It is a .MAT file for
% ease/efficiency of loading, but can be edited to add new arguments.
% Can add these manually or change buildOptions = 1 with new additions, and
% run THIS section only (Ctrl+Enter in Windows)
% These match up, e.g. defaultArgs{3} is the default for allowedArgs{3}
% if not overridden by user arguments.
%
% For now, you will need to manually override CF with the right array, and
% it must/should be corresponded with the character array. This may be
% changed in the future, after extensive testing of speed/memory.
buildOptions = 0;

if buildOptions
    warning('Options file building is ON. Turn off in iparse().')
    allowedArgs = {'Background', 'Fundamentals', 'WhitePoint', ...
        'Lin', ...
        'Primaries', ...
        'CAT', ...
        'Space', ...
        'MBScale', 'LMScale', ...
        'Direction', ...
        'Order', ...
        'Origin', 'AxisScale', 'AxisRotation', ...
        'FromWP', 'ToWP', ...
        'UseCd', ...
        'CalculateTransform', ...
        'RestoreLuminance'};
    defaultArgs = {[0.5 0.5 0.5], 'CF_StockmanSharpe_2deg', 'D65_2', ...
        'Gamma', ...
        'Default', ...
        'SS', ...
        'Cartesian', ...
        [0.689903, 0.348322, 0.0371597], 1, ...
        'Regular', 'LMSLMLum', ...
        [0.6568, 0.01825], [1955, 5533], [0 0], ...
        'D65_2','D65_2', ...
        0, ...
        1, ...
        1};
    allowedParameters = {{}, {}, {}, ... %Fundamentals and WhitePoints are less strict
        {'sRGB','Gamma','L','None'}, ...
        {'Default', 'sRGB', 'Apple RGB', 'AppleRGB', 'Adobe'}, ...
        {'ss','stockmansharpe','stockman & sharpe','vke','vonkriesE','von kries e','hpee','vkd65','vonkriesd65','von kries d65','hped65','brainard','old'}, ...
        {'Cartesian','Spherical','Polar'}, ...
        {}, {}, ...
        {'Regular','Classic'}, ...
        {'LMSLMLum', 'LumLMSLM'}, ...
        {}, {}, {}, ...
        {}, {}, {}, ...
        {}, ...
        {}};


%wps = 'A_2','A_10','C_2','C_10','D50_2','D50_10','D55_2','D55_10','D65_2','D65_10','D75_2','D75_10','F11_2','F11_10','F2_2','F2_10','F7_2','F7_10','E','CCT','B_2'
    textValidator = str2func("@(x)validateattributes(x, {'char', 'string'}, {'scalartext'})");
    numValidator = str2func("@isnumeric");
    boolValidator = str2func("@(x)validateattributes(x, {'logical','numeric'}, {'<=', 1, '>=', 0})"); %{'>=',0,'<=',1});
    
    validatorParameters = {numValidator, textValidator, textValidator, ...
        textValidator, textValidator, textValidator, textValidator, ...
        numValidator, numValidator, ...
        textValidator, textValidator, ...
        numValidator, numValidator, numValidator, ...
        textValidator, textValidator, boolValidator, boolValidator, boolValidator};

    structNames = {'Argument', 'Default', 'Parameters', 'Validator'};
    structVals = {allowedArgs, defaultArgs, allowedParameters, validatorParameters};
    options = struct([]);
    for cArgs = 1:length(allowedArgs)
        options(cArgs).Argument = allowedArgs{cArgs};
        options(cArgs).Default = defaultArgs{cArgs};
        options(cArgs).Parameters = allowedParameters{cArgs};
        options(cArgs).Validator = validatorParameters{cArgs};
    end
        % Add array of fundamentals, will be changed.
    load('cfs.mat',defaultArgs{2});
    cf = eval(defaultArgs{2});
    clearvars -except options cf
    save('parameter_options.mat', 'options', 'cf');
end
%% Load available parameters & defaults
load('parameter_options.mat')

%% Check for invalid parameter names
invalid = {};
lVars = length(varargin);
% if lVars ~= 0 && ~isinteger(lVars/2); error("Supplied arguments require 'Name', Value pairs"); end
allowedArgs = {options.Argument}; % Get Argument names, overriding above
if lVars ~= 0
    %todo cell of just args vs cell of cell not via {:}
    requestedArgs = varargin(1:2:end);
    %requestedVals = varargin(2:2:end);
    if ~all(contains(upper(requestedArgs), upper(allowedArgs)))
        error('Argument supplied is not valid.')
    end
end
%todo check req vals too



%% Inputs
addRequired(p, 'data');%, @class(x) trival);
%addParameter(p, 'Background', NaN);% isColor)

for i = 1:length(allowedArgs)
    addParameter(p, options(i).Argument, options(i).Default, options(i).Validator)
end
% addParameter(p, dFundamentals{:});
% addParameter(p, dPrimaries{:});%{:}, @(x) any(validatestring(x, vPrimaries)));
% addParameter(p, dSpace{:});
% %addParameter(p, dLinearizing{1}, dLinearizing{2}, @(x) any(validatestring(x, vLinearizing)));
% addParameter(p, dLinearizing{:});
% addParameter(p, dOrigin{:}, @isnumeric);
% addParameter(p, dAxisScale{:}, @isnumeric);
% addParameter(p, dAxisRotation{:}, @isnumeric);
% addParameter(p, dMBScale{:});
% addParameter(p, dCAT{:});%, vCAT);
%if p.FunctionName or inputname(1)

%% Parse
parse(p, data, varargin{:})
inputParserObject = p;
% Send fundamentals to main workspace
if exist('cf', 'var')
    f = cf;
else
    f = loadFundamentals(p.Results.Fundamentals);
end
assignin('base', 'fundamentals', f);
end