function cyl = toCylindrical(in1976)
%TOCYLINDRICAL Nested function for converting Lab and Luv Cartesian _to_
%cylindrical

% Split to separate variables for readability
[L, au, bv] = deal(in1976(1), in1976(2), in1976(3));

%% Trig to wraparound x/y
% L = L % Don't need to change
C = sqrt(au^2 + bv^2);

if atan2d(bv, au) >= 0 %todo check
    H = atan2d(bv, au);
else
    H = atan2d(bv, au) + 360;
end

cyl = [L C H] ;

end