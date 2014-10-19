function addNodes(v, node_file, edge_file, varargin)	
%MRIcroS('addNodes','a.node', 'a.edge')
%MRIcroS('addNodes','a.node', '') %no edge file!
%MRIcroS('addNodes','a.node', 'a.edge', 2)
%MRIcroS('addNodes','a.node', 'a.edge', 2, 2)
%MRIcroS('addNodes','a.node', '', 2) % no edges
%MRIcroS('addNodes','a.node', 'a.edge', 2, 2, 'hsv') %plot nodes with 'hsv'
%inputs: 
% 1) node_filepath
% 2) edge_filepath: sepecify as '' if no edges to be loaded
% Inputs below are optional
% 3) nodeRadiusThreshold: filter for nodes with radius above threshold
%   any edges connected to a filtered node will be removed as well
% 4) edgeWeightThreshold: filter for edges above specified threshold
%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910


[node_file, isFound] = fileUtils.isFileFound(v, node_file);
if ~isFound
    fprintf('Unable to find "%s"\n',node_file); 
    return; 
end;
if ~fileUtils.isNode(node_file), fprintf('Odd extension for a node file %s\n',node_file); end;
if (nargin < 3)
  edge_file = '';  
end
nodeThreshold = -inf;
edgeThreshold = -inf;
colorMap = 'jet';
if (length(varargin) >= 1) && isnumeric(varargin{1}), nodeThreshold = varargin{1}; end;
if (length(varargin) >= 2) && isnumeric(varargin{2}), edgeThreshold = varargin{2}; end;
if (length(varargin) >= 3), colorMap = varargin{3}; end;

loadEdges = ~isempty(edge_file);
if loadEdges 
    [edge_file, isFound] = fileUtils.isFileFound(v, edge_file);
    if ~isFound
        fprintf('Unable to find "%s"\n',edge_file); 
        return; 
    end
end;

[ ~, nodes, ~] = fileUtils.brainNet.readNode(node_file);
edges = [];
if(loadEdges)
    if ~fileUtils.isEdge(edge_file), fprintf('Odd extension for an edge file %s\n',edge_file); end;
    edges = fileUtils.brainNet.readEdge(edge_file);
end
if (nodeThreshold > -inf || edgeThreshold > -inf)
    [nodes, passingNodeIndexes] = ...
        utils.brainNet.filterNodes(nodes, nodeThreshold);
    if(loadEdges)
        edges = ...
            utils.brainNet.filterEdges(edges, edgeThreshold, passingNodeIndexes);
    end
end
    
[renderedNodes, renderedEdges] = drawing.brainNet.plotBrainNet(nodes, edges, colorMap);
hasBrainNets = isfield(v,'brainNets');
brainNetsIndex = 1;
if(hasBrainNets) brainNetsIndex = brainNetsIndex + length(v.brainNets); end
v.brainNets(brainNetsIndex).renderedNodes = renderedNodes;
v.brainNets(brainNetsIndex).renderedEdges = renderedEdges;
guidata(v.hMainFigure, v);
v = drawing.removeDemoObjects(v);
guidata(v.hMainFigure, v);
%end function addNodes()
    