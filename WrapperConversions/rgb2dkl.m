function DKL = rgb2dkl(RGB, varargin)
%RGB2DKL Convert from RGB to DKL space
%Wrapper, passes through LMS cone activations
%   dkl = rgb2dkl(bkgdRGB, rgb) takes RGB value bkgdRGB as the origin
%   and rgb as the target color.
%       dkl = rgb2dkl([0.5 0.5 0.5, [1 0 1]) sets magenta on a medium gray background.
%
%   dkl = rgb2dkl(bkgdRGB, rgb, ,'Fundamentals', cfs) Uses cone
%   fundamentals in the \Fundamentals\ path to load a different cone
%   function assumption. If left out, default Stockman & Sharpe (2000)
%   2-degree fundamentals are chosen.


[ci, phos] = loadCI();

%% Get Inputs
p = iparse(RGB, varargin{:});
%p = inputParser;
%p.KeepUnmatched = true;
% Validator(s)
% % % validWavelengthMatrix = @(x) isnumeric(x) && size(x,2) == 4;
%validColorInput = @(x) size(x,2) == 3;
% % % validSpaces = {'cartesian', 'polar'};
% % % validOrder = {'LMSLMLum', 'LumLMSLM'};
% % % validDirections = {'Regular','Classic'};

% Required parameters to run this
% addRequired(p, 'phos', validWavelengthMatrix);
%addRequired(p, 'bkgdRGB', validColorInput);
addRequired(p, 'RGB', validColorInput);

% Optionals:
% Fundamentals are always used whether supplied or not
%addParameter(p, 'Fundamentals', load(strcat(pwd,'\Fundamentals\StockmanSharpe_lin_2deg.mat')));
% % % addParameter(p, 'Fundamentals', ci.Fundamentals);
% % % addParameter(p, 'Space', 'Cartesian', @(x) any(validatestring(x, validSpaces)));
% % % addParameter(p, 'Order', 'LMSLMLum', @(x) any(validatestring(x, validOrder)));
% % % addParameter(p, 'Direction', 'Regular', @(x) any(validatestring(x, validDirections)));

% % Axis scaling, todo fix
% addParameter(p, 'LumScale', 1, @isnumeric)
% addParameter(p, 'LMScale', 1, @isnumeric)
% addParameter(p, 'SLMScale', 1, @isnumeric)

% Get values out

%parse(p, bkgdRGB, RGB, varargin{:})
%passthru = p.Unmatched;

% % % if isstruct(p.Results.Fundamentals)
% % %     % If it was loaded above, it's struct in struct
% % %     fcfs = p.Results.Fundamentals.cfs;
% % % elseif isnumeric(p.Results.Fundamentals) && size(p.Results.Fundamentals,2) == 4
% % %     % Otherwise it's supplied
% % %     fcfs = p.Results.Fundamentals;
% % % else
% % %     error('There is an issue with supplied cone fundamentals, or default is not present and loading.')
% % % end

%% Calculations
bkgdRGB = p.Results.Background;
bkgdLMS = rgb2lms(bkgdRGB, varargin{:});
LMS = rgb2lms(RGB, varargin{:});
DKL = lms2dkl(bkgdLMS, LMS, varargin{:});
end

