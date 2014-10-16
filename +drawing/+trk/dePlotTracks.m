function dePlotTracks(v, ~)
%function dePlotTracks(v)
hasTracks = isfield(v, 'tracks');
if(hasTracks)
	tracks = v.tracks;
	arrayfun(@(t)(delete(t.fibers)), tracks);

end
