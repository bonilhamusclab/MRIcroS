function [renderedNodes, renderedEdges] = plotBrainNetOld(nodes, edges, colorMap)
%function [renderedNodes, renderedEdges] = plotBrainNetOld(nodes, edges)
%inputs:   
%   nodes
%   edges: set to [] if none should be plotted
%   colorMapFn (optional): map for the node color function, default is jet
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910

if nargin < 3, colorMap = 'jet'; end;

alsoPlotEdges = ~isempty(edges);
if(alsoPlotEdges && numel(edges) > length(nodes)^2)
    error('num edges (%d) must be less than the square of num nodes (%d)',...
        numel(edges), length(nodes));
end

[xSph, ySph, zSph] = sphere(20);
xCs = nodes(:,1);
yCs = nodes(:,2);
zCs = nodes(:,3);
rads = nodes(:,5);
cols = nodes(:,4);

numNodes = size(nodes, 1);
renderedNodes = zeros(1, numNodes);
nodeColors = utils.magnitudesToColors(cols./max(cols), colorMap);

for i = 1:numNodes
    hold on
    x = xSph.*rads(i) + xCs(i);
    y = ySph.*rads(i) + yCs(i);
    z = zSph.*rads(i) + zCs(i);
    nodeColor = nodeColors(i,:);
    %renderedNodes(i) = mesh(x,y,z,'EdgeColor', nodeColor, 'FaceColor', nodeColor);
    renderedNodes(i) = mesh(x,y,z,'EdgeColor', 'none', 'FaceColor', nodeColor);
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
    numEdges = sum(edgesBinary(:));

    renderedEdges = zeros(numEdges);
    usedEdges = edges(edgeIdxs);
    edgeRange =max(usedEdges(:)) -  min(usedEdges(:)); %'range' does not exist in Matlab 2012
    normalizedEdges = (edges(:) - min(usedEdges(:)))./edgeRange;
    %normalizedEdges = (edges(:) - min(edges(:)))./range(edges(:));
    
    edgeColors = utils.magnitudesToColors(normalizedEdges, colorMap);
    for i = 1:numEdges
        edgeIdx = edgeIdxs(i);
        hold on
        
        x = [xStarts(edgeIdx) xStops(edgeIdx)];
        y = [yStarts(edgeIdx) yStops(edgeIdx)];
        z = [zStarts(edgeIdx) zStops(edgeIdx)];
        
        edgeW = edges(edgeIdx);
        edgeC = edgeColors(edgeIdx,:);
        renderedEdges(i) = plot3(x,y,z, 'LineWidth', edgeW, 'Color', edgeC);
    end
end %if alsoPlotEdges

% end plotBrainNet()