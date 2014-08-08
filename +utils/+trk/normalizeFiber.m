function normalizedFiber = normalizeFiber(fiber, header, voxToRas)
%normalizedFiber = normalizeFiber(fiber, header, voxToRas)
%inputs:
%	voxToRas: specifiy if vox_to_ras in header is not appropriate
	voxel_size = header.voxel_size;	
	for i= 1:3
		fiber(:, i) = fiber(:, i)./voxel_size(i);
	end

	if(nargin == 2) voxToRas = header.vox_to_ras; end;

	nPoints = size(fiber, 1);
	normalizedFiber = voxToRas * [fiber ones(nPoints, 1)]';
	normalizedFiber = normalizedFiber';
