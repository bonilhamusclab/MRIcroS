function [faces, vertices, vertexColors, colorMap, colorMin] = readMesh(varargin)
%function openMesh(filename)
% --- open pre-generated vtk or gii mesh
% --- gii processing requires spm
%Examples
% readMesh('myImg.vtk');
% readMesh('myImg.vtk',0.5); % 50% reduction
vertexColors = [];
colorMap = utils.colorTables(1);
colorMin = 0;
if (nargin) && (ischar(varargin{1})) 
 filename = varargin{1};
else
	error('readMesh expects filename');
end
if fileUtils.isGifti(filename) && (~exist('gifti.m', 'file') == 2)
    fprintf('Unable to open GIfTI files: this feature requires SPM to be installed');
end;
reduce = 1;
if (nargin > 1) && isnumeric(varargin{2}) %16 Oct 2014
    reduce = varargin{2};
end

if fileUtils.isPly(filename)
    [faces, vertices, vertexColors] = fileUtils.ply.readPly(filename);
elseif fileUtils.isNv(filename)
    [faces, vertices] = fileUtils.nv.readNv(filename);
elseif fileUtils.isPial(filename)
    [faces, vertices] = fileUtils.pial.readPial(filename);
elseif fileUtils.isStl(filename)
    [faces, vertices] = fileUtils.stl.readStl(filename);
elseif fileUtils.isMat(filename)
    [faces, vertices, vertexColors, colorMap, colorMin] = fileUtils.mat.readMat(filename);
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