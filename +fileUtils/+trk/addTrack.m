% --- Load trackvis fibers http://www.trackvis.org/docs/?subsect=fileformat
function addTrack(v,filename, trackSpacing, fiber_len)
%  filename
%MATcro('addTrack','dti.trk', 100)
	if(nargin < 3) trackSpacing = 100; end
	if(nargin < 4) fiber_len = 5; end
tic
    hold on
    [header,data] = fileUtils.trk.readTrack(filename);
	dataLen = length(data);
	ptr = 1;
	renderedFiberIndex = 1;
	while ptr < dataLen
		track = utils.trk.extractTrack(data, header, ptr);
		ptr = utils.trk.skipTracks(data, header, ptr, trackSpacing);
		nPoints = size(track, 1);
		if nPoints>fiber_len
			normalizedTrack = utils.trk.normalizeTrack(track, header);
			x = normalizedTrack(:,1);
			y = normalizedTrack(:,2);
			z = normalizedTrack(:,3);
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
            renderedFibers(renderedFiberIndex) = plot3(x,y,z,'LineWidth',1,'Color',col);
			renderedFiberIndex = renderedFiberIndex + 1;
            hold on
		end
	end

	hasTrack = isfield(v,'tracks');
	tracksIndex = 1;
	if(hasTrack) tracksIndex = tracksIndex + length(v.tracks); end
	v.tracks(tracksIndex).fibers = renderedFibers(1:renderedFiberIndex - 1);
	guidata(v.hMainFigure, v);
	drawing.removeDemoObjects(v);
    
toc
%end addTrack()
