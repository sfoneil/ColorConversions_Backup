function Lab = rgb2lab(RGB, varargin)
%RGB2LAB Convert RGB to Lab
%   Detailed explanation goes here

fh = overloadConversion('rgb2lab');

Lab = feval(fh, RGB, varargin{:});
end

