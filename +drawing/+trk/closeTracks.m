function closeTracks(v)
%function closeTracks(v, eventdata)
hasTracks = isfield(v, 'tracks');
if(hasTracks)
	tracks = v.tracks;
	arrayfun(@(t)(delete(t.fibers)), tracks);
	v = rmfield(v, 'tracks');
	guidata(v.hMainFigure, v);
end
