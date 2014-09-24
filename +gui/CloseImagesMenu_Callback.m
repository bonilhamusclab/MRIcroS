function CloseImagesMenu_Callback(obj, eventdata)
% --- close all open images
v=guidata(obj);
commands.closeImages(v);
%end CloseOverlaysMenu_Callback()
