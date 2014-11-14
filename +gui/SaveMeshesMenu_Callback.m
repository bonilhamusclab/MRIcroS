function SaveMeshesMenu_Callback(obj, eventdata)
% --- allow user to specify file name to export meshes
if (exist('gifti.m', 'file') == 2)
    [file,path] = uiputfile({'*.mat','MAT';'*.ply','PLY (e.g. MeshLab)';'*.vtk','VTK (e.g. FSLview)';'*.gii','GIfTI (e.g. SPM8)'},'Save mesh');
else
    [file,path] = uiputfile({'*.mat','MAT';'*.ply','PLY (e.g. MeshLab)';'*.vtk','VTK (e.g. FSLview)'},'Save mesh');
end
if isequal(file,0), return; end;
filename=[path file];
v=guidata(obj);
MRIcroS('saveMesh', filename);
%end SaveMeshesMenu_Callback()
