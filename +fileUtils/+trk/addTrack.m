% --- Load trackvis fibers http://www.trackvis.org/docs/?subsect=fileformat
function addTrack(v,filename, trackSpacing, fiber_len)
%  filename
%MATcro('addTrack','dti.trk', 100)
	if(nargin < 3) trackSpacing = 100; end
	if(nargin < 4) fiber_len = 5; end
tic
    hold on
    [header,data] = fileUtils.trk.readTrack(filename);
	renderedFibers = drawing.trk.plotTrack(header, data, trackSpacing, fiber_len);

	hasTrack = isfield(v,'tracks');
	tracksIndex = 1;
	if(hasTrack) tracksIndex = tracksIndex + length(v.tracks); end
	v.tracks(tracksIndex).fibers = renderedFibers;
	guidata(v.hMainFigure, v);
	v = drawing.removeDemoObjects(v);
    
toc
%end addTrack()
