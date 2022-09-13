function [outDKL] = DKL_flip(inDKL, Direction)

%function [outDKL] = DKL_flip(convDir, inDKL, varargin)
%DKL_FLIP Rotates DKL from working space to typical space where:
%   right == +L-M == red
%   up == +S-(L+M) == blue
%   left == -L+M == green
%   down == -S+(L+M) == yellow
%   Assumes order is [Lum LM SLM]

%% Parse inputs
convDirections = {'lms2dkl', 'dkl2lms'};
validDirections = {'Regular','Classic'};
p = inputParser;
%addRequired(p, 'convDir', @(x) any(validatestring(x, convDirections)));
addRequired(p, 'inDKL', @isnumeric);
addRequired(p, 'Direction', @(x) any(validatestring(x, validDirections)));
%addParameter(p, 'Direction', 'Regular', @(x) any(validatestring(x, validDirections)));
parse(p, inDKL, Direction);

%% Flip if needed
%if strcmpi(p.Results.convDirections, 'lms2dkl')
    if strcmpi(p.Results.Direction, 'Classic')
%         warning(['Argument ''Classic'' puts red left and blue down per original DKL paper. ' ...
%             'This is now atypical. Use argument ''Regular'' to use typical standards.'])
        outDKL = [inDKL(:,1), inDKL(:,2:3).*-1]; % Flip L-M S-LM
    else %Not doing elseif, typo means use the regular one
        outDKL = [inDKL(:,1), inDKL(:,2:3).*-1]; % Flip L-M S-LM
    end
% elseif strcmpi(p.Results.convDirections, 'dkl2lms')
%     if strcmpi(p.Results.Direction, 'Classic')
%         warning(['Argument ''Classic'' puts red left and blue down per original DKL paper. ' ...
%             'This is now atypical. Use argument ''Regular'' to use typical standards.'])
%         outDKL = inDKL;
%     else %Not doing elseif, typo means use the regular one
%         outDKL = [inDKL(:,1), inDKL(:,2:3).*-1]; % Flip L-M S-LM
%     end
% end
end

