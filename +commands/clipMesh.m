function clipMesh(v, layer, minXYZ, maxXYZ)	
%Remove triangles that extend beyond specified location
%  layer: object to clip
%  minXYZ : lower limit of each dimension: positions less than this clipped
%  maxXYZ : upper limit of each dimension: positions more than this clipped
%Examples
% MRIcroS('clipMesh',1,[0 -inf -inf], [inf inf inf]) %clip low X (LEFT)
% MRIcroS('clipMesh',1,[-inf -inf -inf], [0 inf inf]) %clip high X (RIGHT)
% MRIcroS('clipMesh',1,[-inf 0 -inf], [inf inf inf]) %clip low Y (POSTERIOR)
% MRIcroS('clipMesh',1,[-inf -inf -inf], [inf 0 inf]) %clip high Y (ANTERIOR)
% MRIcroS('clipMesh',1,[-inf -inf 0], [inf inf inf]) %clip low Z (INFERIOR)
% MRIcroS('clipMesh',1,[-inf -inf -inf], [inf inf 0]) %clip high Z (SUPERIOR)
%Chris Rorden, 10/2014

if(isfield(v, 'surface'))
    surfaceCount = length(v.surface);
else
    return
end
if (layer > surfaceCount)
    fprintf('%s error: you have only loaded %d layers',mfilename,surfaceCount);
    return;
end
%OPTIONAL: report range of vertices in each dimension
minXYZsrc(1) = min(v.surface(layer).vertices(:,1));
minXYZsrc(2) = min(v.surface(layer).vertices(:,2));
minXYZsrc(3) = min(v.surface(layer).vertices(:,3));
maxXYZsrc(1) = max(v.surface(layer).vertices(:,1));
maxXYZsrc(2) = max(v.surface(layer).vertices(:,2));
maxXYZsrc(3) = max(v.surface(layer).vertices(:,3));
fprintf('minXYZ= [%.3f %.3f %.3f]; maxXYZ=[%.3f; %.3f; %.3f]\n',minXYZsrc(1),minXYZsrc(2),minXYZsrc(3),maxXYZsrc(layer),maxXYZsrc(2),maxXYZsrc(3) );
%find vertices to delete
vertOK = ones(size(v.surface(layer).vertices,1),1);
vertOK = vertOK - (v.surface(layer).vertices(:,1) < minXYZ(1)); %delete low X
vertOK = vertOK - (v.surface(layer).vertices(:,2) < minXYZ(2)); %delete low Y
vertOK = vertOK - (v.surface(layer).vertices(:,3) < minXYZ(3)); %delete low Z
vertOK = vertOK - (v.surface(layer).vertices(:,1) > maxXYZ(1)); %delete high X
vertOK = vertOK - (v.surface(layer).vertices(:,2) > maxXYZ(2)); %delete high Y
vertOK = vertOK - (v.surface(layer).vertices(:,3) > maxXYZ(3)); %delete high Z
vertOK (vertOK < 0) = 0; %some vertices might be deleted multiple times
if sum(vertOK(:)) == 0
    fprintf('No vertices would survive this clipping\n');
    return;
end
if sum(vertOK(:)) == size(v.surface(layer).vertices,1)
    fprintf('All vertices survive this clipping\n');
    return;
end
nFacesIn = size(v.surface(layer).faces,1);
%%Example data to understand logic: delete 1st, 2nd, 5th vertices
%vertOK = [0 0 1 1 0 1]; layer = 1; v.surface(layer).faces = [1 2 3; 1 2 4; 6 4 3; 1 2 5; 3 4 6]; 
vertOK(vertOK == 1) = 1: sum(vertOK(:)); %[0 0 1 2 0 3]
v.surface(layer).faces = vertOK(v.surface(layer).faces); %next: relabel surviving vertices, zero those to delete
v.surface(layer).faces(any(v.surface(layer).faces==0,2),:)=[]; %next: delete unused vertices
fprintf('Reduced mesh from %d to %d faces\n', nFacesIn, size(v.surface(layer).faces,1));
%next remove unused vertex colors
if size(v.surface(layer).vertices,1) == size(v.surface(layer).vertexColors,1)
   v.surface(layer).vertexColors(vertOK == 0,:) = [];
end
%finally, remove unused vertices
v.surface(layer).vertices(vertOK == 0,:) = [];
fprintf('Reduced mesh from %d to %d vertices\n', numel(vertOK), size(v.surface(layer).vertices,1));
%save settings and refresh view
v = drawing.redrawSurface(v);
guidata(v.hMainFigure,v);
%end clipMesh()

