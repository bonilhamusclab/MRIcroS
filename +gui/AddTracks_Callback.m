% --- allow user to add deterministic tracks
function AddTracks_Callback(obj, eventdata)
v=guidata(obj);
[track_filename, track_pathname] = uigetfile( ...
    {'*.trk;', 'trk files'; ...
    '*.*',                   'All Files (*.*)'}, ...
    'Select a Track (trk) file');
    if isempty(track_filename), disp('load tracks cancelled'); return; end;
    track_filename=[track_pathname track_filename];
    prompt = {'Track Sampling (1/ts tracks will be loaded, increases speed but decreases information):','Minimum fiber length (only sampled tracks with this minimum fiber length will be rendered, increases speed but decreases information):'};
	ans = inputdlg(prompt, 'Track Options', 1, {num2str(100), num2str(5)});
	trackSpacing = str2double(ans(1));
	fiberLen = str2double(ans(2));
    fileUtils.trk.addTrack(v,track_filename, trackSpacing, fiberLen);
%end Add_tracks_Callback()
