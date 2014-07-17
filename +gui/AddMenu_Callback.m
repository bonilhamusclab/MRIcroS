% --- add a new voxel image or mesh as a layer with default options
function AddMenu_Callback(obj, eventdat)
v=guidata(obj);
fileUtils.SelectFileToOpen(v,'', Inf, 0.25, 0);
%end AddMenu_Callback()
