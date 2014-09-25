function addTrack(v, filename, varargin)	
%MRIcroS('addTrack','dti.trk')
%MRIcroS('addTrack','dti.trk', 100)
%MRIcroS('addTrack','dti.trk', 50, 10)
%inputs: 
% 1) filename
% 2) fiber sampling space: 1/x tracks will be sampled (default 1)
% 3) minimun fiber length (default 5)
% --- Load trackvis fibers http://www.trackvis.org/docs/?subsect=fileformat
	if (nargin < 2), return; end;
	inputs = cell2mat(varargin);
    if(length(inputs) == 1)
	  addTrackSub(v, filename, inputs(1));
	elseif(length(inputs) == 2)
	  addTrackSub(v, filename, inputs(1), inputs(2));
	else
	  addTrackSub(v, filename);
    end
%end addTrack()


function addTrackSub(v,filename, trackSpacing, fiber_len)
	if(nargin < 3), trackSpacing = 100; end
	if(nargin < 4), fiber_len = 5; end
tic
    hold on
    [header,data] = fileUtils.trk.readTrack(filename);
	renderedFibers = drawing.trk.plotTrack(header, data, trackSpacing, fiber_len);

	hasTrack = isfield(v,'tracks');
	tracksIndex = 1;
	if(hasTrack), tracksIndex = tracksIndex + length(v.tracks); end
	v.tracks(tracksIndex).fibers = renderedFibers;
	guidata(v.hMainFigure, v);
	drawing.removeDemoObjects(v);
    
toc
%end addTrackSub()
