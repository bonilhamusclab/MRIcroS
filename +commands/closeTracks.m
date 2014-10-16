function closeTracks(v)
%MRIcroS('closeTracks');

if isfield(v, 'tracks')
	drawing.trk.dePlotTracks(v);
    v = rmfield(v, 'tracks');
	guidata(v.hMainFigure, v);
end


