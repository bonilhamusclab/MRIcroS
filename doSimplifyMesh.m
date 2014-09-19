function doSimplifyMesh(v,reduce)
% --- reduce mesh complexity
if (reduce >= 1) || (reduce <= 0), disp('simplify ratio must be between 0..1');  return; end;
for i=1:length(v.surface)
    FVr = reducepatch(v.surface(i),reduce);
    fprintf('Mesh reduced %d->%d vertices and %d->%d faces\n',size(v.surface(i).vertices,1),size(FVr.vertices,1),size(v.surface(i).faces,1),size(FVr.faces,1) );
    v.surface(i).faces = FVr.faces;
    v.surface(i).vertices = FVr.vertices;
    clear('FVr');    
end;
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end doSimplifyMesh()
