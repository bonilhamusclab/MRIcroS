function SaveMeshesMenu_Callback(obj, eventdata)
% --- allow user to specify file name to export meshes
if (exist('gifti.m', 'file') == 2)
    [file,path] = uiputfile({'*.gii','GIfTI (e.g. SPM8)';'*.vtk','VTK (e.g. FSLview)';'*.ply','PLY (e.g. MeshLab)'},'Save mesh');
else
    [file,path] = uiputfile({'*.ply','PLY (e.g. MeshLab)';'*.vtk','VTK (e.g. FSLview)'},'Save mesh');
end
if isequal(file,0), return; end;
filename=[path file];
v=guidata(obj);
fileUtils.saveMesh(v, filename);
%end SaveMeshesMenu_Callback()
