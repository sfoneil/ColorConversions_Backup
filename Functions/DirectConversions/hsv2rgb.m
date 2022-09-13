function RGB = hsv2rgb(HSV, varargin)
%HSV2RGB Convert HSV to RGB
%   Detailed explanation goes here

fh = overloadConversion('hsv2rgb');

RGB = feval(fh, HSV, varargin{:});

end

