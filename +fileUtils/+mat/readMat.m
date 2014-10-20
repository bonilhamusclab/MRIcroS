function [faces, vertices, vertexColors, colorMap, colorMin] = readMat(fileName)
%Load triangle data from Mat file
faces = [];
vertices = [];
vertexColors = []; %add vertexColors
colorMap = 1;
colorMin = 0;
s = load(fileName);
if ~isfield(s,'vertices') || ~isfield(s,'faces')
   fprintf('Invalid format: This file does not describe a mesh %s\n',fileName);
   return; 
end
%next - read required items
faces = s.faces;
vertices = s.vertices;
%next - read optional values specific to vertex colors
if isfield(s,'colorMap') 
    colorMap = s.colorMap;
end
colorMap = utils.colorTables(colorMap);
if isfield(s,'colorMin') 
    colorMin = s.colorMin;
end
if (colorMin >= 1), colorMin = 0; end;
colorMin = utils.boundArray(colorMin,0,0.95);
if isfield(s,'vertexColors') 
    vertexColors = s.vertexColors;
end
%end readMat()