function SaveMeshesMenu_Callback(obj, ~)
% --- allow user to specify file name to export meshes
if (exist('gifti.m', 'file') == 2)
    [file,path] = uiputfile({'*.ply','PLY (e.g. MeshLab)';'*.trib','tri-binary';'*.vtk','VTK (e.g. FSLview)';'*.gii','GIfTI (e.g. SPM8)'},'Save mesh');
else
    [file,path] = uiputfile({'*.ply','PLY (e.g. MeshLab)';'*.trib','tri-binary';'*.vtk','VTK (e.g. FSLview)'},'Save mesh');
end
if isequal(file,0), return; end;
filename=[path file];
v=guidata(obj);
fileUtils.saveMesh(v, filename);
%end SaveMeshesMenu_Callback()
