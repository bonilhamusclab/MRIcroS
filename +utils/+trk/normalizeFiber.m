function normalizedFiber = normalizeFiber(fiber, header)
%normalizedFiber = normalizeFiber(fiber, header)
	voxel_size = header.voxel_size;	
	for i= 1:3
		fiber(:, i) = fiber(:, i)./voxel_size(i);
	end
	%change to ras
	nPoints = size(fiber, 1);
	normalizedFiber = header.vox_to_ras *[fiber ones(nPoints, 1)]';
	normalizedFiber = normalizedFiber';
