function [heartFV, sphereFV] = createDemoObjects
% --- generate initial background volume: make heart and sphere shapes
vox=48;
[X,Y,Z]=ndgrid(linspace(-3,3,vox),linspace(-3,3,vox),linspace(-3,3,vox));
F=((-(X.^2) .* (Z.^3) -(9/80).*(Y.^2).*(Z.^3)) + ((X.^2) + (9/4).* (Y.^2) + (Z.^2)-1).^3);
heartFV = isosurface(F,0);
F = sqrt(X.^2 + Y.^2 + Z.^2);
sphereFV = isosurface(F,0.4);
%end createDemoObjects()
