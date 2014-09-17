%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910
function dePlotBrainNets(v)
%function dePlotBrainNets(v)
hasBrainNets = isfield(v, 'brainNets');
if(hasBrainNets)
    numBrainNets = length(v.brainNets);
    for i = 1:numBrainNets
        brainNet = v.brainNets(i);
        
        renderedNodes = brainNet.renderedNodes;
        arrayfun(@(n)(delete(n)), renderedNodes);
        
        renderedEdges = brainNet.renderedEdges;
        %renderedEdges is symmatric around the diagonal, but we don't want
        %to try to remove the same edge twice, invoking delete twice on 
        %same handle throws an error
        edgesBelowDiag = renderedEdges & ~tril(renderedEdges);
        %only remove edges that exist (calling delete(0) will throw error)
        edgesToRemove = renderedEdges(edgesBelowDiag ~= 0);
        arrayfun(@(e)(delete(e)), edgesToRemove);
    end
end
