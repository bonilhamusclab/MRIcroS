function closeLayers(v, layerIndxs)
%MRIcroS('closeLayers', layerIndxs);
%if layerIndxs not set, close all open surfaces

if nargin < 2
    layerIndxs = -1;
end

v = guidata(v.hMainFigure);
if(isfield(v, 'surface'))
    if layerIndxs < 0
        v = rmfield(v,'surface');
    else
        v.surface(layerIndxs) = [];
        if isempty(v.surface)
            v = rmfield(v, 'surface');
        end
    end
    guidata(v.hMainFigure,v);
end

if(~isfield(v, 'surface'))
    drawing.createDemoObjects(v, true);
else
    drawing.redrawSurface(v);
end

end