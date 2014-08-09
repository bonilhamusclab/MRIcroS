function normalizedFiber = normalizeFiber(fiber, voxToRas)
%normalizedFiber = normalizeFiber(fiber, voxToRas)

	nPoints = size(fiber, 1);
	normalizedFiber = voxToRas * [fiber ones(nPoints, 1)]';
	normalizedFiber = normalizedFiber';
