function writeMat(vertices,vertexColors,faces,filename, colorMap, colorMin)
%Save mesh in MATLAB format
s.vertices = vertices;
s.faces = faces;
s.vertexColors = vertexColors;
s.colorMap = colorMap;
s.colorMin = colorMin;
%explicitly request v7 for compression and compatibility
% http://undocumentedmatlab.com/blog/improving-save-performance
save(filename,'-v7','-struct', 's');
%save(filename,'-struct', 's');
%end writeMat()
