function [track nextTrackIndex] = extractTrack(data, header, trackIndex)
	pointDim = 3 + header.n_scalars;
	numPts = data(trackIndex);

	pointsStart = trackIndex + 1;
	pointsEnd = trackIndex + numPts * pointDim + header.n_properties;

	%return numPts x pointDim matrix, but data is x y z x2 y2 z2 etc..
	track = reshape(data(pointsStart:pointsEnd),[pointDim numPts])';
	nextTrackIndex = pointsEnd + 1;
