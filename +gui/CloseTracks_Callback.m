function CloseTracks_Callback(h, eventdata)
v = guidata(h);
hasTracks = isfield(v, 'tracks');
if(hasTracks)
	tracks = v.tracks;
	tracks
	arrayfun(@(t)(delete(t.fibers)), tracks);
	v = rmfield(v, 'tracks');
	guidata(v.hMainFigure, v);
end
