function flipped = flipAxes(x, axesToFlip)
%function flipped = flipAxes(x, axesToFlip)
%outputs:
%	flipped: a flipped version of x on the axes specified by axesToFlip
%inputs:
%	x: a nxm vector (n number of axes, m number of samples) to be flipped
%	axesToFlip: a length n vector where 1 means flip and 0 means dont flip

flipped = x;
numFlips = length(axesToFlip);
for i=1:numFlips
	axis = axesToFlip(i);
	flipped(axis,:) = -1* x(axis,:);
end
