function plotHandles = plotTrack(header, data, fiberSpacing, fiber_len)
	if(nargin < 3) fiberSpacing = 100; end
	if(nargin < 4) fiber_len = 5; end

	voxToRas = header.vox_to_ras;%utils.trk.prepAffine(header);
	dataLen = length(data);
	ptr = 1;
	renderedFiberIndex = 1;
	while ptr < dataLen
		fiber = utils.trk.extractFiber(data, header, ptr);
		ptr = utils.trk.skipFibers(data, header, ptr, fiberSpacing);
		nPoints = size(fiber, 1);
		if nPoints>fiber_len
			normalizedFiber = utils.trk.normalizeFiber(fiber, header);
			plotHandles(renderedFiberIndex) = drawing.trk.plotFiber(fiber);
			renderedFiberIndex = renderedFiberIndex + 1;
            hold on
		end
	end
