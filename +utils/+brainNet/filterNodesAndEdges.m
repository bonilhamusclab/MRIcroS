function [ filteredNodes, filteredEdges ] = filterNodesAndEdges(...
    nodes, edges, nodeRadiusThreshold, edgeWeightThreshold )
%function [ filteredNodes, filteredEdges ] = thresholdNodesAndEdges(...
%    nodes, edges, nodeRadiusThreshold, edgeThreshold )
%filter for nodes with a radius above specified threshold
%   any edges connected to filtered node will be removed as well
%filter for edges that have weight above specified threshold

rads = nodes(:,5);
passingNodeIndxs = find(rads > nodeRadiusThreshold);

filteredNodes = nodes(passingNodeIndxs, :);


filteredEdges = edges(passingNodeIndxs,passingNodeIndxs);

filteredEdges(filteredEdges < edgeWeightThreshold) = 0;

end
