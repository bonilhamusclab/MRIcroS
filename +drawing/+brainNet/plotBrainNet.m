function [renderedNodes, renderedEdges] = plotBrainNet(nodes, edges, colorMap)
%function [renderedNodes, renderedEdges] = plotBrainNet(nodes, edges)
%inputs:   
%   nodes
%   edges: set to [] if none should be plotted
%   colorMapFn (optional): map for the node color function, default is jet
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910

if nargin < 3, colorMap = 'jet'; end;
colorMapFn = str2func(colorMap);

alsoPlotEdges = ~isempty(edges);
if(alsoPlotEdges && numel(edges) ~= numel(nodes)^2)
    error('num edges (%d) must equal the square of num nodes (%d)',...
        numel(edges), numel(nodes));
end

[xSph, ySph, zSph] = sphere(20);

xCs = nodes(:,1);
yCs = nodes(:,2);
zCs = nodes(:,3);
rads = nodes(:,5);
cols = nodes(:,4);

numNodes = size(nodes, 1);

renderedNodes = zeros(1, numNodes);

colorMap = colorMapFn(max(cols));

for i = 1:numNodes
    hold on
    x = xSph.*rads(i) + xCs(i);
    y = ySph.*rads(i) + yCs(i);
    z = zSph.*rads(i) + zCs(i);
    nodeColor = colorMap(cols(i), :);
    renderedNodes(i) = mesh(x,y,z,'EdgeColor', nodeColor, 'FaceColor', nodeColor);
end

renderedEdges = [];
if(alsoPlotEdges)
    edgesBinary = edges ~= 0 & ~tril(edges);

    %several times faster than double for loop
    xStarts = bsxfun(@times, edgesBinary, xCs);
    xStops = bsxfun(@times, edgesBinary, xCs');
    yStarts = bsxfun(@times, edgesBinary, yCs);
    yStops = bsxfun(@times, edgesBinary, yCs');
    zStarts = bsxfun(@times, edgesBinary, zCs);
    zStops = bsxfun(@times, edgesBinary, zCs');

    edgeIdxs = find(edgesBinary);
    numEdges = length(edgeIdxs);

    renderedEdges = zeros(numNodes);
    for i = 1:numEdges
        edgeIdx = edgeIdxs(i);
        hold on
        x = [xStarts(edgeIdx) xStops(edgeIdx)];
        y = [yStarts(edgeIdx) yStops(edgeIdx)];
        z = [zStarts(edgeIdx) zStops(edgeIdx)];
        renderedEdges(edgeIdx) = plot3(x,y,z);
    end
end

end