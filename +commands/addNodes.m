function addNodes(v, node_filepath, edge_filepath, ...
    nodeRadiusThreshold, edgeWeightThreshold, colorMap)	
%MRIcroS('addNodes','a.node', 'a.edge')
%MRIcroS('addNodes','a.node', 'a.edge', 2)
%MRIcroS('addNodes','a.node', 'a.edge', 2, 2)
%MRIcroS('addNodes','a.node', '', 2) % no edges
%MRIcroS('addNodes','a.node', 'a.edge', 2, 2, 'hsv') %plot nodes with 'hsv'
%colormap
%inputs: 
% 1) node_filepath
% 2) edge_filepath: sepecify as '' if no edges to be loaded
% Inputs below are optional
% 3) nodeRadiusThreshold: filter for nodes with radius above threshold
%   any edges connected to a filtered node will be removed as well
% 4) edgeWeightThreshold: filter for edges above specified threshold
%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910
    
    
    if(nargin < 3)
        nodeRadiusThreshold = -inf;
    end
    if(nargin < 4)
        edgeWeightThreshold = -inf;
    end
	if(nargin < 5)
        colorMap = 'jet';
    end
    
    loadEdges = ~strcmp(edge_filepath,'');
    
    [ ~, nodes, ~] = fileUtils.brainNet.readNode(node_filepath);
    
    edges = [];
    if(loadEdges)
        edges = fileUtils.brainNet.readEdge(edge_filepath);
    end
    
    if (nodeRadiusThreshold > -inf || edgeWeightThreshold > -inf)
        [nodes, passingNodeIndexes] = ...
            utils.brainNet.filterNodes(nodes, nodeRadiusThreshold);
        if(loadEdges)
            edges = ...
                utils.brainNet.filterEdges(edges, edgeWeightThreshold, passingNodeIndexes);
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
