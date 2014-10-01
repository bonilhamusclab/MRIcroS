function [faces, vertices] = readMesh(filename)
%function openMesh(filename)
% --- open pre-generated vtk or gii mesh
% --- gii processing requires spm

[~, ~, ext] = fileparts(filename);

if (length(ext) == 4) && strcmpi(ext,'.gii') && (~exist('gifti.m', 'file') == 2)
    fprintf('Unable to open GIfTI files: this feature requires SPM to be installed');
end;

if (length(ext) == 4) && strcmpi(ext,'.gii')
    gii = gifti(filename);
     faces = double(gii.faces); %convert to double or reducepatch fails
     vertices = double(gii.vertices); %convert to double or reducepatch fails
else
    [gii.vertices, gii.faces] = fileUtils.vtk.readVtk(filename);
     faces = gii.faces'; 
     vertices = gii.vertices'; 
end;