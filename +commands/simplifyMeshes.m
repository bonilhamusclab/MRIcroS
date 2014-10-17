function simplifyMeshes(v, reduce, meshIndx)
%function simplifyMeshes(v, reduce, meshIndx)
% ---  reduce mesh complexity
%MRIcroS('simplifyMeshes', 0.2); %reduce mesh to 20% complexity
% inputs: 
%   reduce: 
%       reduction ratio
%   meshIndx (optional): 
%       index of mesh to reduce
%       defaults to every mesh if not specified

if(nargin < 2)
    meshIndx = 0;
end

doSimplifyMeshSub(v, reduce, meshIndx);

%end simplifyMeshes()

function doSimplifyMeshSub(v,reduce, meshIndx)
if (reduce >= 1) || (reduce <= 0), disp('simplify ratio must be between 0..1');  return; end;
startIndx = 1;
endIndx = length(v.surface);

if(meshIndx)
	startIndx = meshIndx; endIndx = meshIndx;
end

for i=startIndx:endIndx
    FVr = reducepatch(v.surface(i),reduce);
    v.surface(i).vertexColors = []; %CRV colors no longer correspond to vertices.
    fprintf('Mesh reduced %d->%d vertices and %d->%d faces\n',size(v.surface(i).vertices,1),size(FVr.vertices,1),size(v.surface(i).faces,1),size(FVr.faces,1) );
    v.surface(i).faces = FVr.faces;
    v.surface(i).vertices = FVr.vertices;
    clear('FVr');    
end;

v = drawing.redrawSurface(v);
guidata(v.hMainFigure,v);%store settings
%end doSimplifyMeshSub()
