function structCAM02 = xyz2ciecam02(XYZ, XYZwp, lumAdapt varargin)
%XYZ2CIECAM02 Convert XYZ coordinates to CIECAM02 color appearance space.
%Measures color APPEARANCE, so two colors that are judged a match may have
%different CIE1931 values but appear the same.

%   SSSSSSSSS
%   SSSSSSSSS
%   SSbbbbbSS
%   SSbbbbbSS
%   SSbbCbbSS
%   SSbbbbbSS
%   SSbbbbbSS
%   SSSSSSSSS
%   SSSSSSSSS

% XYZ = object
% XYZwp = white point used
% la = lum of adapting
% yb = y background
% S = surround, general lighting conditions
% b = background, behind object
% C = object

validSurrounds = {'Average', 'Dim', 'Dark'};
p = inputParser;
addRequired('XYZ', @isnumeric);
addRequired('XYZwp', @isnumeric);
addParameter(p, 'Surround', 'Average'); %is one of 3 or numbers

parse(p, 'XYZ', 'XYZwp', varargin{:});

p.Results.WhitePoint = XYZwp;
% Get whitepoint vector from illuminants struct
load illuminants.mat % Load illuminants struct
wp = eval(strcat('si.', p.Results.WhitePoint));
clearvars si % Remove from memory

% Get surround values F, c, Nc
% F: factor determining degree of adaptation
% c: impact of surrounding
% Nc: chromatic induction factor
if strcmpi(surround, 'Average')
    fcn = [1.0 0.69 1.0];
elseif strcmpi(surround, 'Dim')
    fcn = [0.9 0.59 0.95];
elseif strcmpi(surround, 'Dark')
    fcn = [0.8 0.525 0.8];
else
    %fcn = numberzzzz
end

% Matrix to convert in CAT02
mCAT = [0.7328 0.4296 -0.1624;
    -0.7036 1.6975 0.0061;
    0.0030 0.0136 0.9834];

% Get start values dependent of view conditions
k = 1 ./ (5 .* lumAdapt + 1);
Fl = (k.^4 * lumAdapt) + ...
    (0.1 .* (1 - k.^4).^2 .*) ...
    ((5.*lumAdapt).^(1/3));
n = Yb ./ XYZwp(2);
Nbb = 0.725 .* ((1/n).^0.2);
z = 1.48 = sqrt(n);

% Get RGB values corresponding to CIECAM02 XYZ conversions
RGB = mCat * XYZ';
RGBwp = mCat * XYZwp';

% Degree of adapation, this value can be overridden based on how strongly
% adapted
D  = fcn(1) .* (1 - (1/3.6) .* ...
    ((-lumAdapt - 42)./92) ...
    );
Rc = (D .* XYZwp(2) / RGBwp(1) + 1 - D) .* RGB(1);
Gc = (D .* XYZwp(2) / RGBwp(2)) + 1 - D) .* RGB(2);
Gc = (D .* XYZwp(2) / RGBwp(3)) + 1 - D) .* RGB(3);
RGBc(1, :) = (D .* XYZwp(2) / RGBwp(1) + 1 - D) .* RGB(1,:);
RGBc(2, :) = (D .* XYZwp(2) / RGBwp(2) + 1 - D) .* RGB(2,:);
RGBc(3, :) = (D .* XYZwp(2) / RGBwp(3) + 1 - D) .* RGB(3,:);

end

