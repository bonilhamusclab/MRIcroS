function affine = prepAffine(header)
%function affine = prepAffine(header)

	voxel_size = header.voxel_size;	
	affine = header.vox_to_ras;
	for i= 1:3
		affine(:, i) = affine(:, i)./voxel_size(i);
	end

	affine = utils.trk.orientAffine(affine, header.voxel_order);
