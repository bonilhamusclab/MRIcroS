function CloseLayers_Callback(obj, eventdata)
% --- close all open layers
v=guidata(obj);
commands.closeLayers(v);
%end CloseLayers_Callback()
