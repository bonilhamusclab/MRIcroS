function [renderedNodes, renderedEdges] = plotBrainNet(nodes, edges)
%function [renderedNodes, renderedEdges] = plotBrainNet(nodes, edges)
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910

[xSph, ySph, zSph] = sphere(20);

xCs = nodes(:,1);
yCs = nodes(:,2);
zCs = nodes(:,3);
rads = nodes(:,5);

numNodes = size(nodes, 1);

renderedNodes = zeros(1, numNodes);

for i = 1:numNodes
    hold on
    x = xSph.*rads(i) + xCs(i);
    y = ySph.*rads(i) + yCs(i);
    z = zSph.*rads(i) + zCs(i);
    renderedNodes(i) = mesh(x,y,z,'EdgeColor','red');
end

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
