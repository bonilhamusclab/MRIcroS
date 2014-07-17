% --- allow user to add deterministic tracks
function AddTracks_Callback(obj, eventdata)
v=guidata(obj);
[track_filename, track_pathname] = uigetfile( ...
    {'*.trk;', 'trk files'; ...
    '*.*',                   'All Files (*.*)'}, ...
    'Select a Track (trk) file');
    if isempty(track_filename), disp('load tracks cancelled'); return; end;
    track_filename=[track_pathname track_filename];
    fileUtils.trk.addTrack(obj,track_filename);    
%end Add_tracks_Callback()
