function [fiber, nextFiberIndex] = extractFiber(data, header, fiberIndex)
	%function [fiber nextFiberIndex] = extractFiber(data, header, fiberIndex)
	pointDim = 3 + header.n_scalars;
	numPts = data(fiberIndex);

	pointsStart = fiberIndex + 1;
	pointsEnd = fiberIndex + numPts * pointDim + header.n_properties;

	%return numPts x pointDim matrix, but data is x y z x2 y2 z2 etc..
	fiber = reshape(data(pointsStart:pointsEnd),[pointDim numPts]);
	nextFiberIndex = pointsEnd + 1;
