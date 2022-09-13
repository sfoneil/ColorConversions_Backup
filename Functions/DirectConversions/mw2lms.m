function LMS = mw2lms(MW, varargin)
%MW2LMS Summary of this function goes here
%   Detailed explanation goes here

p = iparse(MW, varargin{:});

[LM, SLM, Lum] = deal(MW(:,1), MW(:,2), MW(:,3));

MB = mw2mb(MW, varargin{:});
LMS = mb2lms(MB, varargin{:});

% L = LM ./ 2754 + 0.6568;
% M = 1 - L;
% S = SLM ./ 4099 + 0.01825;
% LMS = [L M S];
%     % Convert from myspace coordinates to the LMS values
%     Lresp = LMval / 2754 + 0.6568;
%     Mresp = 1 - Lresp;
%     Sresp = Sval / 4099 + .01825;
%     coneresp = [Lresp Mresp Sresp]';
%
end

