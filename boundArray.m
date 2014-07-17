% --- clip all values of 'in' to the range min..max
function [out] = boundArray(in, min,max)
out = in;
i = out > max;
out(i) = max;
i = out < min;
out(i) = min;
%end boundArray()
