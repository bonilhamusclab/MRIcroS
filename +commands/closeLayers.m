function closeLayers(v, ~)
%MRIcroS('closeLayers');
% --- close all open volume surfaces
v = guidata(v.hMainFigure);
if(isfield(v, 'surface'))
    if (~isempty(v.surface)) 
        v = rmfield(v,'surface');
        guidata(v.hMainFigure,v);%store settings
        %drawing.redrawSurface(v);
    end; 
end
drawing.createDemoObjects(v, true);
%end closeLayers()