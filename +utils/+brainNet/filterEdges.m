function filteredEdges = filterEdges(edges, edgeWeightThreshold, passingNodeIndexs)
%function filteredEdges = filterEdges(edges, edgeWeightThreshold, passingNodeIndxs)
%filter for edges that have weight above specified threshold
%inputs:
%   edgeWeightThreshold: any edges with weight below this threshold will be
%   zeroed
%   passingNodeIndexes (optional): only keep edges with these indexes,
%   used in scenarios where nodes are filtered

removeForMissingNodes = nargin > 2;

if(removeForMissingNodes)
    filteredEdges = edges(passingNodeIndexs,passingNodeIndexs);
end

filteredEdges(filteredEdges < edgeWeightThreshold) = 0;

end
