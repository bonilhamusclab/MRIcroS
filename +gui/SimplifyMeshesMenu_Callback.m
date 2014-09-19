function SimplifyMeshesMenu_Callback(obj, eventdata)
% --- allow user to specify parameters for reducing mesh complexity
v=guidata(obj);
reduce = 0.25;
prompt = {'Reduce Path, e.g. 0.5 means half resolution (0..1):'};
dlg_title = 'Select options for loading image';
def = {num2str(reduce)};
answer = inputdlg(prompt,dlg_title,1,def);
if isempty(answer), disp('simplify cancelled'); return; end;
reduce = str2double(answer(1));
doSimplifyMesh(v,reduce)
%end SimplifyMeshesMenu_Callback()
