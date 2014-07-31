function normalizedTrack = normalizeTrack(track, header)
%normalizedTrack = normalizeTrack(track, header)
	voxel_size = header.voxel_size;	
	for i= 1:3
		track(:, i) = track(:, i)./voxel_size(i);
	end
	%change to ras
	nPoints = size(track, 1);
	normalizedTrack = header.vox_to_ras *[track ones(nPoints, 1)]';
	normalizedTrack = normalizedTrack';
