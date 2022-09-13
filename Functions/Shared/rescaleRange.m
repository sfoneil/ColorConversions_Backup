function trivalOut = rescaleRange(trivalIn, ToRange) %varargin)
%RESCALERANGE Change range of a trivalue color space, e.g. 0...1 range to
%or from 0...100

p = inputParser;
addRequired(p, 'trivalIn')
addRequired(p, 'ToRange')
parse(p, trivalIn, ToRange); % varargin);

if any(trivalIn > 1)
    FromRange = 100;
    if ToRange == 1
        trivalOut = trivalIn ./ 100;
    else
        trivalOut = trivalIn;
    end
else
    FromRange = 1;
    if ToRange == 100
        trivalOut = trivalIn .* 100;
    else
        trivalOut = trivalIn;
    end
end



end

