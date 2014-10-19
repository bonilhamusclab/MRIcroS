function closeLayers(v, ~)
%MRIcroS('closeLayers');
% --- close all open volume surfaces
v = guidata(v.hMainFigure);
if(isfield(v, 'surface'))
    if (~isempty(v.surface)) 
        v = rmfield(v,'surface');
        v = drawing.createDemoObjects(v);
        guidata(v.hMainFigure,v);%store settings
        drawing.redrawSurface(v);
    end; 
end
%end closeLayers()
