function nvToOpen (v, filename, isBackground)
%function nvToOpen (v, filename, isBackground)
% filename: pial or nv image to open
if isequal(filename,0), return; end;
if exist(filename, 'file') == 0, fprintf('Unable to find %s\n',filename); return; end;

if (isBackground) 
    v = drawing.removeDemoObjects(v);
end;

[faces, vertices] = fileUtils.nv.readNv(filename);

layer = utils.fieldIndex(v, 'surface');
v.surface(layer).faces = faces;
v.surface(layer).vertices = vertices;
v.vprefs.demoObjects = false;

%display results
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);