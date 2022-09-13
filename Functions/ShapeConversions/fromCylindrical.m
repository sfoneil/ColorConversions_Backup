function cart = fromCylindrical(in1976)
%FROMCYLINDRICAL
%   Nested function for converting Lab and Luv cylindrical _to_
    %Cartesian.


% Split to separate variables for readability
[L, C, h] = deal(in1976(1), in1976(2), in1976(3));

%% Trig to flatten in x/y
% L = L % Don't need to change
au = C * cosd(h);
bv = C * sind(h);

cart = [L au bv] ;

end