function surfaceToOpen (v, isBackground, readFileFn, filename, reduce, smooth, thresh)
%function surfaceToOpen (readFileFn, v, filename, reduce, isBackground)
% filename: pial or nv image to open
% --- open pial or nv surface image
if isequal(filename,0), return; end;
if exist(filename, 'file') == 0, fprintf('Unable to find %s\n',filename); return; end;

if (isBackground) 
    v = drawing.removeDemoObjects(v);
end;

[faces, vertices] = readFileFn(filename, reduce, smooth, thresh);

layer = utils.fieldIndex(v, 'surface');
v.surface(layer).faces = faces;
v.surface(layer).vertices = vertices;
v.vprefs.demoObjects = false;

%display results
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
