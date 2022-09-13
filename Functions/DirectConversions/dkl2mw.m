function MW = dkl2mw(DKL)
%DKL2MW Summary of this function goes here
%   Detailed explanation goes here

LM = (DKL(:,1) - 0.6568) * 1955; %2754;
SLM = (DKL(:,2) - 0.01825) * 5533; %4099;

MW = [LM SLM DKL(:,3)];

end

