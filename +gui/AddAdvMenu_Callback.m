% --- add a new voxel image or mesh as a layer, allow user to specify options
function AddAdvMenu_Callback(obj, eventdata)
v=guidata(obj);
SelectFileToOpen(v,'', NaN, 0.25, 0 );
%end AddAdvMenu_Callback()
