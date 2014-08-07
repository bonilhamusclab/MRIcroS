function plotHandles = plotTrack(header, data, fiberSpacing, fiber_len)
	if(nargin < 3) fiberSpacing = 100; end
	if(nargin < 4) fiber_len = 5; end

	dataLen = length(data);
	ptr = 1;
	renderedFiberIndex = 1;
	while ptr < dataLen
		fiber = utils.trk.extractFiber(data, header, ptr);
		ptr = utils.trk.skipFibers(data, header, ptr, fiberSpacing);
		nPoints = size(fiber, 1);
		if nPoints>fiber_len
			normalizedFiber = utils.trk.normalizeFiber(fiber, header);
			x = normalizedFiber(:,1);
			y = normalizedFiber(:,2);
			z = normalizedFiber(:,3);
            x_first=x(1);
            x_last=x(end);
            y_first=y(1);
            y_last=y(end);
            z_first=z(1);
            z_last=z(end);
            % x displacement
            xdisp=abs(x_first-x_last);
            % y displacement
            ydisp=abs(y_first-y_last);
            % z displacement
            zdisp=abs(z_first-z_last);
            % relative x displacement
            Rxdisp=xdisp/(xdisp+ydisp+zdisp);
            Rydisp=ydisp/(xdisp+ydisp+zdisp);
            Rzdisp=zdisp/(xdisp+ydisp+zdisp);
            col=[Rxdisp,Rydisp,Rzdisp];
            % plot
            plotHandles(renderedFiberIndex) = plot3(x,y,z,'LineWidth',1,'Color',col);
			renderedFiberIndex = renderedFiberIndex + 1;
            hold on
		end
	end
