function voxToRasFn = voxToRasFnGen(header)
%function voxToRasFn = voxToRasFnGen(header)

	%Old solution: off by 0.5 * voxel_size
	% voxel_size = header.voxel_size;
	% affine = header.vox_to_ras;
	% for i= 1:3
	%	affine(:, i) = affine(:, i)./voxel_size(i);
	% end

	%CR 2Sept2016, tested with TrackVis using data from https://github.com/neurolabusc/spmScripts/blob/master/nii_makeDTI.m
	mat = eye(4); %we will use a 4x4 spatial transform
	mat(:,4) = [-0.5 -0.5 -0.5 1]'; %raw coordinates at voxel center (0.5), translate for 0-indexed
	mat(1,1) = 1/header.voxel_size(1);
	mat(2,2) = 1/header.voxel_size(2);
	mat(3,3) = 1/header.voxel_size(3);
	affine = (mat' * header.vox_to_ras')';


	affOrnt = utils.trk.affineOrientation(affine);
	voxelOrder = strcat(header.voxel_order, ''); %facilate processing
	notMatched = find(affOrnt ~= voxelOrder);

	if(sum(notMatched))
		issueWarning(affOrnt, voxelOrder);
    end

	putInAffSpace = @(x)(utils.trk.flipAxes(x, notMatched));
	voxToRasFn = @(x)(affine*[putInAffSpace(x); ones(1, size(x,2))]);

function issueWarning(affOrnt, voxelOrder)
	warning(['afffine orientation (%s), and ',...
		'voxel order (%s) do no match. Using voxel order'], ...
		affOrnt, voxelOrder);
