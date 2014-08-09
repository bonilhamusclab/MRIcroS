function voxToRasFn = voxToRasFnGen(header)
%function voxToRasFn = voxToRasFnGen(header)

	voxel_size = header.voxel_size;	
	affine = header.vox_to_ras;
	for i= 1:3
		affine(:, i) = affine(:, i)./voxel_size(i);
	end

	affOrnt = utils.trk.affineOrientation(affine);
	voxelOrder = strcat(header.voxel_order, ''); %facilate processing

	notMatched = find(affOrnt ~= voxelOrder);
	
	putInAffSpace = @(x)(utils.trk.flipAxes(x, notMatched));

    voxToRasFn = @(x)(affine*[putInAffSpace(x); ones(1, size(x,2))]);
