function closeNodes(v, ~)
%MRIcroS('closeNodes');
%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910
    if isfield(v, 'brainNetLayers')
        commands.closeLayers(v, v.brainNetLayers);
    end
end