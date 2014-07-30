function CloseTracks_Callback(obj, eventdata)
v=guidata(obj);
hasTracks = isfield(v, 'tracks');
if(hasTracks)
	tracks = v.tracks;
	arrayfun(@(t)(delete(t.fibers)), tracks);
	v = rmfield(v, 'tracks');
	guidata(obj, v);
end
