% --- close all open images
function closeOverlays(v)
if (~isempty(v.surface)) 
    v = rmfield(v,'surface');
    [heartFV, sphereFV] = createDemoObjects;
    v.surface(1) = heartFV;
    v.surface(2) = sphereFV;
    v.vprefs.demoObjects = true;
    guidata(v.hMainFigure,v);%store settings
    redrawSurface(v);
else
    fprintf('Unable to close overlays: no overlays loaded\n');
end;
%end closeOverlays()
