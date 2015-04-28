function brainNetAlpha(v, layer, varargin)
%MRIcroS('brainNetAlpha', '', nodeAlpha, edgeAlpha) %update node & edge
%alpha for most recently added nodes & edges
%inputs:
%   layer (if empty sets to most recent brainNet added)
%   nodeAlpha (optional): between 0 and 1, defaults to current
%   edgeAlpha (optional): between 0 and 1, defaults to current
%
%function brainNetAlpha(v, layer, nodeAlpha, edgeAlpha)

    if isempty(layer)
    	layer = utils.fieldIndex(v, 'brainNetLayers');
    end
    
    inputParams = parseInputParamsSub(v, layer, varargin);
    nodeAlpha = inputParams.nodeAlpha;
    edgeAlpha = inputParams.edgeAlpha;
    
    if isfield(v, 'brainNetMeta')
        brainNetIndx = find(arrayfun(@(m) m.layer == layer, v.brainNetMeta));
        if isempty(brainNetIndx)
            error('%d not a brain net layer', layer);
            return;
        end
        
        v.vprefs.colors(layer,4) = nodeAlpha;
        
        edgesLayer = v.brainNetMeta(brainNetIndx).edgesLayer;
        if edgesLayer > -1
            v.vprefs.colors(edgesLayer,4) = edgeAlpha;
        end
    else
        return;
    end
    
    guidata(v.hMainFigure, v);
    drawing.redrawSurface(v);

end

function inputParams = parseInputParamsSub(v, layer, args)
    p = inputParser;
    [d.nodeAlpha, d.edgeAlpha] = ...
        drawing.utils.brainNetAlpha(layer, v);
    
    isRatio = @(x) validateattributes(x, {'numeric'}, {'<=', 1, '>=', 0});
    
    p.addOptional('nodeAlpha', 1, utils.unless(@isempty, isRatio));
    p.addOptional('edgeAlpha', 1, utils.unless(@isempty, isRatio));

    p = utils.stringSafeParse(p, args, fieldnames(d), d.nodeAlpha, d.edgeAlpha);
    
    inputParams = p.Results;
end
