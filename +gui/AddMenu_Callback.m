function AddMenu_Callback(obj, eventdat)
% --- add a new voxel image or mesh as a layer with default options
v=guidata(obj);
commands.addLayer(v,'', Inf, 0.25, 0);
%end AddMenu_Callback()
