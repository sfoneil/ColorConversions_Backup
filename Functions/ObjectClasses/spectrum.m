classdef spectrum
    %SPECTRUM Nx2+ spectral data, where the first column is wavelengths of
    %any even spacing, and subsequent columns are the power (e.g. w/sr/m^2)
    %at each wavelength
    %   This data includes monitor phosphors, spectral fundamentals, color
    %   matching functions, etc.
    
    properties
        Property1
    end
    
    methods
        function obj = spectrum(inputArg1,inputArg2)
            %SPECTRUM Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = interpolate(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end

        function outputArge = truncate(obj1, obj2)

        end
    end
end

