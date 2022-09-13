function [outDKL] = DKL_reorder(inDKL, Order)
%DKL_REORDER Summary of this function goes here
%   Detailed explanation goes here

%% Parse inputs
validOrder = {'LMSLMLum', 'LumLMSLM'};
p = inputParser;
addRequired(p, 'inDKL', @isnumeric);
addRequired(p, 'Order');
%addParameter(p, 'CartOrder', 'LMSLMLum', @(x) any(validatestring(x, validOrder)));
parse(p, inDKL, Order);

%% Calc
if strcmpi(Order, 'LumLMSLM')
%     warning(['Argument ''LumLMSLM'' puts input in [Luminance LM SLM] order. ' ...
%         'Use ''LMSLMLum'' for [LM SLM Luminance] order.']);
    outDKL = [inDKL(:,3), inDKL(:,1), inDKL(:,2)];
else
    outDKL = [inDKL(:,2), inDKL(:,3), inDKL(:,1)];
end

end

