function closeOverlays(v)
% --- close all open images
if (~isempty(v.surface)) 
    v = rmfield(v,'surface');
    [cubeFV, sphereFV] = createDemoObjects;
    v.surface(1) = cubeFV;
    v.surface(2) = sphereFV;
    v.vprefs.demoObjects = true;
    guidata(v.hMainFigure,v);%store settings
    drawing.redrawSurface(v);
else
    fprintf('Unable to close overlays: no overlays loaded\n');
end;
%end closeOverlays()
