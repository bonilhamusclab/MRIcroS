function [ filteredNodes, passingNodeIndexes ] = filterNodes(...
    nodes, nodeRadiusThreshold)
%function [ filteredNodes, passingNodeIndexes ] = filterNodes(...
%    nodes, nodeRadiusThreshold)
%inputs:
%   nodes: node matrix from BrainNet .node file
%   nodeRadiusThreshold: filter for nodes with a radius above this
%   threshold
%outputs:
%   filteredNodes: node matrix with filtered node entries removed
%   passingNodeIndexes: indexes of nodes that passed, this result can be
%   sent to filterEdges so that edges attached to filtered nodes are removed

rads = nodes(:,5);
passingNodeIndexes = find(rads > nodeRadiusThreshold);

filteredNodes = nodes(passingNodeIndexes, :);

end
