function closeEdges(v, ~)
%MRIcroS('closeEdges');
%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910

    if isfield(v, 'brainNetMeta')
        
        
        edgesLayers = arrayfun(@(m) m.edgesLayer, v.brainNetMeta);
        metaIxs = edgesLayers > -1;
        
        if isempty(edgesLayers)
            return;
        end
        
        nodesWithEdges = arrayfun( @(m) m.layer, v.brainNetMeta(metaIxs));
        for l = nodesWithEdges
            v.brainNetMeta(l).edgesLayer = -1;
        end
        guidata(v.hMainFigure, v);
        
  	    commands.closeLayers(v, edgesLayers(metaIxs));
    end
end
