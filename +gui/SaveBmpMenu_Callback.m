function SaveBmpMenu_Callback(obj, eventdata)
% --- save screenshot as bitmap image
v=guidata(obj);
[file,path] = uiputfile('*.png','Save image as');
if isequal(file,0), return; end;
fileUtils.saveBitmap(v,[path file]);
%end SaveBmpMenu_Callback()
