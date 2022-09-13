classdef trival < handle
    %TRIVAL A Nx3 matrix defining trivalues defining a stimulus in a particular color space.
    %   Space is defined across multiple domains such as chromaticity or
    %   physiologically-defined color and includes RGB, DKL, etc.
    %   Exceptions: 1964 CIELuv may be defined as Nx3 L u* v* space or
    %   Nx3 L u' v' chromaticity space or unknown luminance Nx2 u' v'
    %   MacLeod-Boynton space may be Nx2 [Red Blue] or Nx3 [Red Blue Lum]
    %   but will be redefined as Nx4 [Red Green Blue Lum] as possible.

    %WIP, may or may not implement
    properties
        SpaceName {mustBeText} = 'null';
        %  Shape(:,3) {mustBeNumeric} = [1 3];
        Value {mustBeNumeric} = [0 0 0];
        % Luminance can be scalar for all values, or same size as Value for
        % individual/all stimuli. May be redundant with a Value in some
        % spaces.
        Luminance {mustBeNumeric} = 0;
    end

    methods (Static)
        function obj = trival(varargin)
            %TRIVAL Construct an instance of this class
            %   Detailed explanation goes here
            if size(varargin, 2) == 1%iscell(varargin)
                obj.SpaceName = varargin{1}{1};
                obj.Value = varargin{1}{2};
                obj.Luminance = varargin{1}{3};
            elseif size(varargin, 2) == 3
                obj.SpaceName = varargin{1};
                obj.Value = varargin{2};
                obj.Luminance = varargin{3};
            end
        end

        function newTrival = conv(strConversion, args)
            %CONV Alternative conversion method
            %   Detailed explanation goes here
            funcs = dbstack;
%p.FunctionName = funcs(2).name;
            fh = str2func(strConversion);
            newTrival = feval(fh, trival.Value, args{:});
        end

    end

end