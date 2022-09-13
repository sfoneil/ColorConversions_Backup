function colorInfo2 = saveLum(lms, k, colorInfo2)
%SAVELUM Function to save DKL values to colorInfo2 for optional direct MB
%conversions. See also SAVEDKL

% Usually k == 2 or k == 1.63
colorInfo2.lum = k .* lms(1) + lms(2);

end

