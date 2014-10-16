function [faces, vertices, vertexColors] = readMesh(filename, varargin)
%function readMesh(filename)
% --- open pre-generated vtk, gii mesh, pial, ply, trib, or NV
% --- gii processing requires spm
%inputs:
%   filename
%   reduction factor (optional)
%       default 1
%       only for file types without vertex colors
%Examples
%readMesh('myImg.vtk');
%readMesh('myImg.vtk',0.5); % 50% reduction
vertexColors = [];

if fileUtils.isGifti(filename) && (~exist('gifti.m', 'file') == 2)
    fprintf('Unable to open GIfTI files: this feature requires SPM to be installed');
end;

reduce = utils.parseInputs(varargin, {1});

if fileUtils.isPly(filename)
    [faces, vertices, vertexColors] = fileUtils.ply.readPly(filename);
elseif fileUtils.isNv(filename)
    [faces, vertices] = fileUtils.nv.readNv(filename);
elseif fileUtils.isPial(filename)
    [faces, vertices] = fileUtils.pial.readPial(filename);
elseif fileUtils.isTrib(filename)
    [faces, vertices, vertexColors] = fileUtils.trib.readTrib(filename);
elseif fileUtils.isGifti(filename)
    gii = gifti(filename);
    faces = double(gii.faces); %convert to double or reducepatch fails
    vertices = double(gii.vertices); %convert to double or reducepatch fails
else
    [gii.vertices, gii.faces] = fileUtils.vtk.readVtk(filename);
     faces = gii.faces'; 
     vertices = gii.vertices'; 
end;

if isempty(vertexColors) && (reduce < 1) && (reduce > 0)
    fv.faces = faces;
    fv.vertices = vertices;
    fv = reducepatch(fv,reduce);
    fprintf('Mesh reduced %d->%d vertices and %d->%d faces\n',size(vertices,1),size(fv.vertices,1),size(faces,1),size(fv.faces,1) );
    faces = fv.faces;
    vertices = fv.vertices;
end
%end readMesh()