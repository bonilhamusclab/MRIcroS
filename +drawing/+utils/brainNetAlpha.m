function [nodeAlpha, edgeAlpha] = brainNetAlpha(layer, v)
%function [nodeAlpha, edgeAlpha] = brainNetAlpha(layer, v)
    
    nodeAlpha = 1.0;
    edgeAlpha = 1.0;

    if isfield(v, 'brainNetMeta')
        brainNetIndx = find(arrayfun(@(m) m.layer == layer, v.brainNetMeta), 1);
        if isempty(brainNetIndx)
            error('%dq not a layer with nodes', layer);
        end
        
        meta = v.brainNetMeta(brainNetIndx);
        
        colors = @(l) v.vprefs.colors(l,:);
        
        clrs = colors(layer);
        nodeAlpha = clrs(1, 4);
        if isfield(meta, 'edgesLayer')
            clrs = colors(meta.edgesLayer);
            edgeAlpha = clrs(1, 4);
        end
    end

end
