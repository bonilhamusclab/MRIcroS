function [sphereHandles, lineHandles] = plotConnections(nodes, edges)
%function plotHandles = plotConnections(nodes, edges)
[xSph, ySph, zSph] = sphere(100);

numNodes = size(nodes, 1);

sphereHandles = zeros(1, numNodes);

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
    putvar(x,y,z);
    sphereHandles(i) = mesh(x,y,z,'EdgeColor','red');
end

lineHandles = zeros(numNodes);
for r = 1:numNodes
    lastColBeforeDiag = r - 1;
    for c = 1:lastColBeforeDiag
        hold on
        if(edges(r, c))
            x = [nodes(r, 1) nodes(c, 1)];
            y = [nodes(r, 2) nodes(c, 2)];
            z = [nodes(r, 3) nodes(c, 3)];
            lineHandles(r,c) = plot3(x,y,z);
            lineHandles(c,r) = lineHandles(r,c);
        end
    end
end

end