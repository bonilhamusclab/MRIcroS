function [cubeFV, sphereFV] = createDemoObjects
% --- generate initial background volume: make cube and sphere shapes
vox=48;
[X,Y,Z]=ndgrid(linspace(-3,3,vox),linspace(-3,3,vox),linspace(-3,3,vox));
cubeThresh = 1.5;
F = abs(X)> cubeThresh | abs(Y)> cubeThresh | abs(Z) > cubeThresh;
cubeFV = isosurface(X, Y, Z, F, 0.1);

[X,Y,Z]=ndgrid(linspace(-3,3,vox),linspace(-3,3,vox),linspace(-3,3,vox));
F = sqrt(X.^2 + Y.^2 + Z.^2);
%7/6 seemed correct emperically
sphereFV = isosurface(X + 5, Y, Z, F, 7/6 * cubeThresh);
%end createDemoObjects()
