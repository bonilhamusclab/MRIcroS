% --- close all open images
function CloseOverlaysMenu_Callback(obj, eventdata)
v=guidata(obj);
closeOverlays(v);
%end CloseOverlaysMenu_Callback()
