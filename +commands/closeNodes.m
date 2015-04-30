function closeNodes(v, ~)
%MRIcroS('closeNodes');
%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910
    if isfield(v, 'brainNetMeta')
        nodeLayers = arrayfun(@(m) m.layer, v.brainNetMeta);
        
        edgesLayers = arrayfun(@(m) m.edgesLayer, v.brainNetMeta);
        edgesLayers = edgesLayers(edgesLayers > -1);
        
        allLayers = [nodeLayers edgesLayers];
        
        v = rmfield(v, 'brainNetMeta');
        guidata(v.hMainFigure, v);
        
        commands.closeLayers(v, allLayers);
    end
end