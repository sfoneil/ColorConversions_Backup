function [outSpace] = DKL_working_space(Conversion, inSpace)
%DKL_WORKING_CONVERSION Converts modern DKL order and axis direction to a
%working space for calculations. This function may be obsolete and removed
%in the future if everything gets converted to standard modern space.
%
%   To/from:
%   1) [LM SLM Lum] and red == right, blue == up
%   2) [Lum LM SLM] and red == left, blue == down

%% Parse inputs
validConversions = {'LumLast', 'LumFirst'}; % To these
p = inputParser;
addRequired(p, 'Conversion', @(x) any(validatestring(x, validConversions)));
addRequired(p, 'inSpace', @isnumeric);
%addParameter(p, 'CartOrder', 'LMSLMLum', @(x) any(validatestring(x, validOrder)));
parse(p, Conversion, inSpace);

%% Conversions
if strcmpi(Conversion, 'LumFirst')
    % Convert 1 --> 2
    outSpace = [inSpace(:,3), inSpace(:,1).*-1, inSpace(:,2).*-1];
elseif strcmpi(Conversion, 'LumLast')
    % Convert 2 --> 1
    outSpace = [inSpace(:,2).*-1, inSpace(:,3).*-1, inSpace(:,1)];
end

end

