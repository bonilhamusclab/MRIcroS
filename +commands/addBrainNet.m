function addBrainNet(v, node_filepath, edge_filepath)	
%MATcro('addBrainNet','a.node', 'a.edge')
%inputs: 
% 1) node_filepath
% 2) edge_filepath
    
    [ ~, nodes, ~] = fileUtils.brainNet.readNode(node_filepath);
    edges = fileUtils.brainNet.readEdge(edge_filepath);
    
    [renderedNodes, renderedEdges] = drawing.brainNet.plotBrainNet(nodes, edges);

	hasBrainNets = isfield(v,'brainNets');
	brainNetsIndex = 1;
	if(hasBrainNets) brainNetsIndex = brainNetsIndex + length(v.brainNets); end
	v.brainNets(brainNetsIndex).renderedNodes = renderedNodes;
    v.brainNets(brainNetsIndex).renderedEdges = renderedEdges;
	guidata(v.hMainFigure, v);
	
    v = drawing.removeDemoObjects(v);
    guidata(v.hMainFigure, v);