function [cLMS] = rgb2lms(RGB, varargin)
%RGB2LMS Convert spectrophotometer-measured monitor RGB gun output in
%w/sr/m^2 to LMS cone activation.
%
%   lms = rgb2lms(phosphors, rgb) loads a saved monitor file and assumes
%   Stockman & Sharpe (2000) 2-degree cone fundamentals.
%
%   
%   Matrices are assumed to be n measurements x 4 columns, where col 1 ==
%   wavelengths, and 2:4 == R, G, B measurements at these wavelengths

% Control for optional function inputs, this will be added to.
% todo: load all data outside of code, in struct
% todo: ? use arguments instead of fixed order

ci = loadCI();

%% Get Inputs
p = iparse(RGB, varargin{:});

%% Calculations

% Constants
phos = ci.Phosphors;
data = RGB.Value;
RGBtoLMStransform = makeRGB_LMStransform(phos);%, p.Results.Fundamentals);
LMS = (RGBtoLMStransform * data')';
cLMS = trival({'LMS', LMS, RGB.Luminance});
end