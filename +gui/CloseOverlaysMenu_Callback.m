function CloseOverlaysMenu_Callback(obj, eventdata)
% --- close all open images
v=guidata(obj);
closeOverlays(v);
%end CloseOverlaysMenu_Callback()
