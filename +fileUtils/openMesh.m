function openMesh(v,filename, isBackground)
%function openMesh(v,filename, isBackground)
% --- open pre-generated mesh
if isequal(filename,0), return; end;
if exist(filename, 'file') == 0, fprintf('Unable to find %s\n',filename); return; end;
[~, ~, ext] = fileparts(filename);
if (length(ext) == 4) && strcmpi(ext,'.gii') && (~exist('gifti.m', 'file') == 2)
    fprintf('Unable to open GIfTI files: this feature requires SPM to be installed');
end;
if (isBackground) 
	v = drawing.removeDemoObjects(v);
end;
layer = utils.fieldIndex(v, 'surface');
if (length(ext) == 4) && strcmpi(ext,'.gii')
    gii = gifti(filename);
     v.surface(layer).faces = double(gii.faces); %convert to double or reducepatch fails
     v.surface(layer).vertices = double(gii.vertices); %convert to double or reducepatch fails
else
    [gii.vertices, gii.faces] = fileUtils.vtk.readVtk(filename);
     v.surface(layer).faces = gii.faces'; 
     v.surface(layer).vertices = gii.vertices'; 
end;
v.vprefs.demoObjects = false;
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end meshToOpen()
