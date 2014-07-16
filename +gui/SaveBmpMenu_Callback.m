% --- save screenshot as bitmap image
function SaveBmpMenu_Callback(obj, eventdata)
v=guidata(obj);
[file,path] = uiputfile('*.png','Save image as');
if isequal(file,0), return; end;
saveBitmap(v,[path file]);
%end SaveBmpMenu_Callback()
