% --- close all open images
function CloseOverlaysMenu_Callback(obj, eventdata)
v=guidata(obj);
doCloseOverlays(v);
%end CloseOverlaysMenu_Callback()
