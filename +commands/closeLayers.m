function closeLayers(v, ~)
%MRIcroS('closeLayers');
% --- close all open volume surfaces

v = guidata(v.hMainFigure);

if(isfield(v, 'surface'))
    if (~isempty(v.surface)) 
        v = rmfield(v,'surface');
        [cubeFV, sphereFV] = drawing.createDemoObjects;
        v.surface(1) = cubeFV;
        v.surface(2) = sphereFV;
        v.vprefs.demoObjects = true;
        v = drawing.redrawSurface(v);
        guidata(v.hMainFigure,v);%store settings
    end;
    
end
%end closeLayers()
