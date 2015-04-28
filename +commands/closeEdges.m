function closeEdges(v, ~)
%MRIcroS('closeEdges');
%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910

    if isfield(v, 'brainNetMeta')
        
        nodesWithEdges = arrayfun( @(m) m.edgesLayer > -1, v.brainNetMeta);
        edgesLayers = arrayfun(@(m) m.edgesLayer, v.brainNetMeta(nodesWithEdges));
        
        for l = nodesWithEdges
            v.brainNetMeta(l).edgesLayer = -1;
        end
        guidata(v.hMainFigure, v);
        
        commands.closeLayers(v, edgesLayers);
    end
end