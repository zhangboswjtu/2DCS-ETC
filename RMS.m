%
% function r = RMS(x1, x2)
%
%   This function returns the RMS between images x1 and x2.



function r = RMS(x1, x2)

error = x1 - x2;

r = sqrt(mean(error(:).^2));
