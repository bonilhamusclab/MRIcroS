function addNodes(v, node_file, varargin)	
%MRIcroS('addNodes','a.node', 'edge_file', 'a.edge')
%MRIcroS('addNodes','a.node', 'edge_file', 'a.edge', 'edgeThreshold', 2)
%MRIcroS('addNodes','a.node', 'edge_file', 'a.edge', 'nodeThreshold', 2)
%MRIcroS('addNodes','a.node', 'nodeThreshold', 2) % no edges
%MRIcroS('addNodes','a.node', 'colorMap', 'hsv') %plot nodes with 'hsv'
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

p = createInputParserSub();
parse(p, varargin{:});

edge_file = p.Results.edge_file;
nodeThreshold = p.Results.nodeThreshold;
edgeThreshold = p.Results.edgeThreshold;
colorMap = p.Results.colorMap;

loadEdges = ~strcmp(edge_file,'');
    
if exist(node_file, 'file') == 0
    [node_file, isFound] = fileUtils.getExampleFile(v.hMainFigure, node_file);
    if ~isFound
        fprintf('Unable to find "%s"\n',node_file); 
        return; 
    end
end;
if loadEdges && exist(edge_file, 'file') == 0
    [edge_file, isFound] = fileUtils.getExampleFile(v.hMainFigure, edge_file);
    if ~isFound
        fprintf('Unable to find "%s"\n',edge_file); 
        return; 
    end
end;

    if(nargin < 4)
        nodeThreshold = -inf;
    end
    if(nargin < 5)
        edgeThreshold = -inf;
    end
    
	if(nargin < 6)
        colorMap = 'jet';
    end
    
    [ ~, nodes, ~] = fileUtils.brainNet.readNode(node_file);
    
    edges = [];
    if(loadEdges)
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
    
%endfunction addNodes()
    
function p = createInputParserSub()
p = inputParser;
p.addParameter('edge_file', '');
p.addParameter('nodeThreshold',0, @(x) validateattributes(x, {'numeric'}, {'nonnegative'}));
p.addParameter('edgeThreshold',0, @(x) validateattributes(x, {'numeric'}, {'nonnegative'}));
p.addParameter('colorMap', 'jet');