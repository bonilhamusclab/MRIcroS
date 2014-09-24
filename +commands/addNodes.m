function addNodes(v, node_filepath, edge_filepath, varargin)	
%MRIcroS('addNodes','a.node', 'a.edge')
%MRIcroS('addNodes','a.node', 'a.edge', 2)
%MRIcroS('addNodes','a.node', 'a.edge', 2, 2)
%inputs: 
% 1) node_filepath
% 2) edge_filepath
% Inputs below are optional
% 3) nodeRadiusThreshold: filter for nodes with radius above threshold
%   any edges connected to a filtered node will be removed as well
% 4) edgeWeightThreshold: filter for edges above specified threshold
%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910
    
	optionalInputs = cell2mat(varargin);
    nodeRadiusThreshold = -inf;
    edgeWeightThreshold = -inf;
    if(length(optionalInputs) == 1)
        nodeRadiusThreshold = optionalInputs(1);
	elseif(length(optionalInputs) == 2)
        nodeRadiusThreshold = optionalInputs(1);
        edgeWeightThreshold = optionalInputs(2);
    end
    
    [ ~, nodes, ~] = fileUtils.brainNet.readNode(node_filepath);
    edges = fileUtils.brainNet.readEdge(edge_filepath);
    
    if (nodeRadiusThreshold > -inf || edgeWeightThreshold > -inf)
        [nodes, edges] = utils.brainNet.filterNodesAndEdges(nodes, edges,...
            nodeRadiusThreshold, edgeWeightThreshold);
    end
    
    [renderedNodes, renderedEdges] = drawing.brainNet.plotBrainNet(nodes, edges);

	hasBrainNets = isfield(v,'brainNets');
	brainNetsIndex = 1;
	if(hasBrainNets) brainNetsIndex = brainNetsIndex + length(v.brainNets); end
	v.brainNets(brainNetsIndex).renderedNodes = renderedNodes;
    v.brainNets(brainNetsIndex).renderedEdges = renderedEdges;
	guidata(v.hMainFigure, v);
	
    v = drawing.removeDemoObjects(v);
    guidata(v.hMainFigure, v);
