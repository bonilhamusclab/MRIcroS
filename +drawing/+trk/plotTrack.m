function plotHandles = plotTrack(header, data, fiberSpacing, fiber_len)
	if(nargin < 3) fiberSpacing = 100; end
	if(nargin < 4) fiber_len = 5; end

	voxToRasFn = utils.trk.voxToRasFnGen(header);
	dataLen = length(data);
	ptr = 1;
	renderedFiberIndex = 0;
	
%	fiber_len = 2
%	fiberSpacing
	
    plotHandles = zeros(1,ceil(dataLen/fiberSpacing));
	while ptr < dataLen
		fiber = utils.trk.extractFiber(data, header, ptr);
		ptr = utils.trk.skipFibers(data, header, ptr, fiberSpacing);
		[~, nPoints] = size(fiber);
		if nPoints>fiber_len

			rasFiber = voxToRasFn(fiber);
			%if renderedFiberIndex == 0
			%	fiber
			%	rasFiber
			%end
            renderedFiberIndex = renderedFiberIndex + 1;
			plotHandles(renderedFiberIndex) = drawing.trk.plotFiber(rasFiber);
            hold on
		end
    end
    if(renderedFiberIndex) 
        plotHandles = plotHandles(1:renderedFiberIndex);
    end
