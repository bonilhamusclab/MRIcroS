function [cubeFV, sphereFV] = createDemoObjects
% --- generate initial background volume: make cube and sphere shapes
vox=48;
[X,Y,Z]=ndgrid(linspace(-3,3,vox),linspace(-3,3,vox),linspace(-3,3,vox));
cubeThresh = 1.5;
F = abs(X)> cubeThresh | abs(Y)> cubeThresh | abs(Z) > cubeThresh;
cubeFV = isosurface(X, Y, Z, F, 0.1);
cubeFV.vertexColors = [];

[X,Y,Z]=ndgrid(linspace(-3,3,vox),linspace(-3,3,vox),linspace(-3,3,vox));
F = sqrt(X.^2 + Y.^2 + Z.^2);
%7/6 seemed correct emperically
sphereFV = isosurface(X + 5, Y, Z, F, 7/6 * cubeThresh);
%CRX - next lines add vertex color: shading based on position of vertex
clr = sphereFV.vertices(:,1);
range = max(clr) - min(clr);
if range ~= 0 %normalize for range 0 (black) to 1 (white)
    clr = (clr - min(clr)) / range;
    sphereFV.vertexColors = [clr clr clr];
end 

%sphereFV

%end createDemoObjects()
