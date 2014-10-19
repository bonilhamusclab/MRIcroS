function normalizedFiber = normalizeFiber(fiber, voxToRas)
%normalizedFiber = normalizeFiber(fiber, voxToRas)

	[~, nPoints] = size(fiber);
	normalizedFiber = voxToRas * [fiber; ones(1, nPoints)];