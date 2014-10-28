function v = createDemoObjects(v, redraw)

if (isfield(v, 'brainNets')) || (isfield(v, 'surface')) || (isfield(v, 'tracks') )
	return;
end
[cubeFV, sphereFV] = createDemoObjectsSub;
v.surface(1) = cubeFV;
v.surface(2) = sphereFV;
v.surface(1).colorMap = utils.colorTables(1);
v.surface(2).colorMap = utils.colorTables(8);
v.surface(1).colorMin = 0.0;
v.surface(2).colorMin = 0.0;
v.vprefs.demoObjects = true; %denote simulated objects
if (nargin > 1) && (redraw)

    guidata(v.hMainFigure, v);%store changes
        drawing.redrawSurface(v);
end
%end createDemoObjects()

function [cubeFV, sphereFV] = createDemoObjectsSub
% --- generate initial background volume: make cube and sphere shapes
vox=48;
[X,Y,Z]=ndgrid(linspace(-3,3,vox),linspace(-3,3,vox),linspace(-3,3,vox));
cubeThresh = 1.5;
F = abs(X)> cubeThresh | abs(Y)> cubeThresh | abs(Z) > cubeThresh;
cubeFV = isosurface(X, Y, Z, F, 0.1);
cubeFV.vertexColors = []; % empty for uncolored objects
[X,Y,Z]=ndgrid(linspace(-3,3,vox),linspace(-3,3,vox),linspace(-3,3,vox));
F = sqrt(X.^2 + Y.^2 + Z.^2);
%7/6 seemed correct emperically
sphereFV = isosurface(X + 2, Y, Z, F, 7/6 * cubeThresh); %make sphere overlapping to show transparency
%next lines add vertex color: shading based on position of vertex
clr = sphereFV.vertices(:,1);
range = max(clr) - min(clr);
if range ~= 0 %normalize for range 0 (black) to 1 (white)
    sphereFV.vertexColors = (clr - min(clr)) / range; %save colors as Scalar not RGB
end 
%end createDemoObjects()
