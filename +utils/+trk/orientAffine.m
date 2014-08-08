function orientedAffine = orientAffine(affine, voxelOrder)
%function orientedAffine = orientAffine(affine, voxelOrder)

	affOrnt = utils.trk.affineOrientation(affine);
	voxelOrder = strcat(voxelOrder, ''); %facilate processing

	notMatched = affOrnt ~= voxelOrder;

	orientedAffine = affine;
	if(sum(notMatched))
		warning(['affine orientation (%s), and ',...
			'voxel order (%s) do not match. Using voxel order'], ...
			affOrnt, voxelOrder);
		orientedAffine(:,notMatched) = -1*affine(:,notMatched);
	end

