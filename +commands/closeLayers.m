function closeLayers(v, ~)
%MRIcroS('closeLayers');
% --- close all open volume surfaces
if(isfield(v, 'surface'))
    if (~isempty(v.surface)) 
        v = rmfield(v,'surface');
        [cubeFV, sphereFV] = drawing.createDemoObjects;
        v.surface(1) = cubeFV;
        v.surface(2) = sphereFV;
        v.vprefs.demoObjects = true;
        guidata(v.hMainFigure,v);%store settings
        drawing.redrawSurface(v);
    end;
    
end
%end closeLayers()
