%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910
function [renderedNodes, renderedEdges] = plotBrainNet(nodes, edges)
%function [renderedNodes, renderedEdges] = plotBrainNet(nodes, edges)
[xSph, ySph, zSph] = sphere(100);

numNodes = size(nodes, 1);

renderedNodes = zeros(1, numNodes);

for i = 1:numNodes
    hold on
    nodeInfo = nodes(i, :);
    xC= nodeInfo(1);
    yC= nodeInfo(2);
    zC= nodeInfo(3);
    rad = nodeInfo(5);
    x = xSph.*rad + xC;
    y = ySph.*rad + yC;
    z = zSph.*rad + zC;
    renderedNodes(i) = mesh(x,y,z,'EdgeColor','red');
end

renderedEdges = zeros(numNodes);
for r = 1:numNodes
    %edges specified b/w nodes in triu matrix
    %assuming no edge b/w node and self
    firstColAfterDiag = r + 1;
    for c = firstColAfterDiag:numNodes
        hold on
        if(edges(r, c))
            x = [nodes(r, 1) nodes(c, 1)];
            y = [nodes(r, 2) nodes(c, 2)];
            z = [nodes(r, 3) nodes(c, 3)];
            renderedEdges(r,c) = plot3(x,y,z);
            renderedEdges(c,r) = renderedEdges(r,c);
        end
    end
end

end
