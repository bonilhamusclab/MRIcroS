function writeTrib(vertex,vertexColors,face,filename)
%Save mesh in trib format
% vertex : M*3 array of vertex coordinates
% vertexColors : empty (=[]), M*1 (scalar) or M*3 (RGB) colors for vertices
% face : X*3 triangle list indexed from 1, e.g. 1,2,3 is a triangle of first 3 vertices
% filename : output name, e.g. 'myFile.trib'
%
% TRIB format specifications:
%   Vertices are indexed from 1, so a triangle of the first 3 vertices is 1,2,3
%   Always LITTLE endian: endian can be determined by reading signature
%  HEADER: first 32 bytes
%   bytes : type : notes
%   0-3: INT32 : SIG signature 
%   4-7: INT32 : NTRI number of triangles
%   8-11: INT32 : NVERT number of vertices
%   12-15: INT32 : NCOLOR color elements per vertex
%     NCOLOR is 0 (XYZ position, no color), 1 (XYZ+intensity) or 3 (XYZ+RGB)
%   16-19: INT32 : UNUSED1 (not yet used)
%   20-23: INT32 : UNUSED2 (not yet used)
%   24-27: FLOAT32 : UNUSED3 (not yet used)
%   28-31: FLOAT32 : UNUSED4 (not yet used)
%  TRIANGLE DATA: next 12*NTRI bytes 
%   +0..3: INT32 : First vertex of first triangle
%   +4..7: INT32 : Second vertex of first triangle
%   +8..11: INT32 :Third vertex of first triangle
%   +12..15: INT32 :First vertex of second triangle
%    ....
%  VERTEX DATA: next 4*NVERT*3 bytes
%   +0..3: FLOAT32 : X of first vertex
%   +4..7: FLOAT32 : Y of first vertex
%   +8..11: FLOAT32 : Z of first vertex
%   +12..15: FLOAT32 : X of second vertex
%   +16..19: FLOAT32 : Y of second vertex
%   +20..23: FLOAT32 : Z of second vertex
%    ....
%  IF NCOLORS > 0 VERTEX DATA: next 4*NVERT*NCOLORS bytes
%   +0..3: FLOAT32: first color of first vertex
%   +4..7: FLOAT32: if NCOLORS = 1: color of 2nd vertex, else 2nd color of 1st vertex
%   ...

[fid,Msg] = fopen(filename,'Wb', 'l');
if fid == -1, error(Msg); end;
[~,~,endian] = computer;
fwrite(fid, 169478669, 'int32'); %SIG to catch ftp conversion errors http://en.wikipedia.org/wiki/Portable_Network_Graphics
fwrite(fid, size(face,1), 'int32'); %NTRI
fwrite(fid, size(vertex,1), 'int32'); %NVERT
fwrite(fid, size(vertexColors,2), 'int32'); %NCOLOR  
fwrite(fid,1,'int32'); %UNUSED1
fwrite(fid,1,'int32'); %UNUSED2
fwrite(fid,1,'float32'); %UNUSED3
fwrite(fid,1,'float32'); %UNUSED4
fwrite(fid,face,'int32'); %triangle indices
fwrite(fid,vertex,'float32'); %vertex coordinates
if  size(vertexColors,1) == size(vertex,1)
    fwrite(fid,vertexColors,'float32');  
end
fclose(fid);
%end writeTrib()
