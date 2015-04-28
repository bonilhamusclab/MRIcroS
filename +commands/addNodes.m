function addNodes(v, node_file, edge_file, varargin)	
%MRIcroS('addNodes','a.node', 'a.edge')
%MRIcroS('addNodes','a.node', '') %no edge file!
%MRIcroS('addNodes','a.node', 'a.edge', 2)
%MRIcroS('addNodes','a.node', 'a.edge', 2, 2)
%MRIcroS('addNodes','a.node', '', 2) % no edges
%MRIcroS('addNodes','a.node', 'a.edge', 2, 2, 'hsv') %plot nodes with 'hsv'
%MRIcroS('addNodes','a.node', 'a.edge', 2, 2, 'hsv', 'jet') %plot nodes
%with 'hsv' & edges with 'jet'
%inputs: 
% 1) node_filepath
% 2) edge_filepath: sepecify as '' if no edges to be loaded
% Inputs below are optional
% 3) nodeThreshold: filter for nodes with radius above threshold
%   any edges connected to a filtered node will be removed as well
% 4) edgeThreshold: filter for edges above specified threshold
% 5) nodeColorMap: color map to be used for nodes
% 6) edgeColorMap: color map to be used for edges
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

inputParams = parseInputParamsSub(varargin);
nodeThreshold = inputParams.nodeThreshold;
edgeThreshold = inputParams.edgeThreshold;
nodeColorMap = inputParams.nodeColorMap;
edgeColorMap = inputParams.edgeColorMap;
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

v = drawing.removeDemoObjects(v);
%this next segment makes sure the nodes are not larger than the image they are drawn on
surfaceCount = 0;
if(isfield(v, 'surface'))
    surfaceCount = length(v.surface);
end
if (surfaceCount > 0)
    rng = zeros(3,1);
    minMM = inf;
    for i=1:surfaceCount
        rng(1) = max(v.surface(i).vertices(:,1))- min(v.surface(i).vertices(:,1));
        rng(2) = max(v.surface(i).vertices(:,2))- min(v.surface(i).vertices(:,2));
        rng(3) = max(v.surface(i).vertices(:,3))- min(v.surface(i).vertices(:,3));
        if min(rng(:)) < minMM, minMM = min(rng(:)); end;
    end
    maxNodeFrac = 0.1; %e.g. if 0.1 a node can not be larger than 10% the size of the object
    if (minMM > 0) && (maxNodeFrac*minMM) < (max(nodes(:,5)))
        scale = maxNodeFrac * (minMM / max(nodes(:,5)));
        fprintf('Nodes larger than rendered object: shrinking node diameter by a factor of %g\n', scale);
        nodes(:,5) = nodes(:,5) * scale;
    end
    
end
%next filter nodes
if (nodeThreshold > -inf || edgeThreshold > -inf)
    [nodes, passingNodeIndexes] = ...
        utils.brainNet.filterNodes(nodes, nodeThreshold);
    if(loadEdges)
        edges = ...
            utils.brainNet.filterEdges(edges, edgeThreshold, passingNodeIndexes);
    end
end

guidata(v.hMainFigure, v);
drawing.brainNet.plotBrainNet(v, nodes, edges, nodeColorMap, edgeColorMap);
%end function addNodes()


function inputParams = parseInputParamsSub(args)
p = inputParser;

d.nodeThreshold = 0; d.edgeThreshold = 0; d.nodeColorMap = 'jet';
d.edgeColorMap = 'jet';


p.addOptional('nodeThreshold',0, utils.unless(@isempty,...
    @(x) validateattributes(x, {'numeric'}, {'real'})));
p.addOptional('edgeThreshold',0, utils.unless(@isempty,... 
    @(x) validateattributes(x, {'numeric'}, {'real'})));
p.addOptional('nodeColorMap', 'jet', utils.unless(@isempty, ...
    @(x) validateattributes(x, {'char'}, {'nonempty'})));
p.addOptional('edgeColorMap', 'jet', utils.unless(@isempty, ...
    @(x) validateattributes(x, {'char'}, {'nonempty'})));

p = utils.stringSafeParse(p, args, fieldnames(d), d.nodeThreshold, d.edgeThreshold, d.nodeColorMap, d.edgeColorMap);

inputParams = p.Results;
    