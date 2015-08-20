function [faces, vertices] = readStl(fileName)
% function [faces, vertices] = readPial(fileName, patchReductionFactor)
%inputs:
%	fileName: the nv file to open
%	patchReductionFactor: optional param specifying whether to reduce faces
%		if not specified .1 reduction performed
%		if specified as 1, no processing performed
%outputs:
%	faces: face matrix where cols are xyz and each row is face
%	vertices: vertices matrix where cols are xyz and each row a vertix
%notes :
% https://en.wikipedia.org/wiki/STL_(file_format)
% similar to Doron Harlev http://www.mathworks.com/matlabcentral/fileexchange/6678-stlread

sz = dir(fileName);
sz = sz.bytes;
if sz < 134 %smallest file is 84 byte header + 50 byte triangle
   error('File too small to be STL format %s', fileName); 
end
fid = fopen(fileName, 'rb', 'l') ; %LITTLE ENDIAN! see wiki
txt80 = fread(fid, 80, 'char') ;
txt = char(txt80(1:5));
if strcmpi(txt','solid') %this is a TEXT stl file
    fclose(fid);
    error('Error: only able to read binary STL files (not ASCII text). Please convert your image: %s', fileName);
end
num_tri = fread(fid, 1, 'uint32') ;
%50 bytes for each triangle there are 12 fp32 and 1 unit16 
min_sz = 80+4+(50*num_tri);
if sz < min_sz 
   error('STL file too small (expected at least %d bytes) %s', min_sz, fileName); 
end
vertices = zeros(num_tri, 9);
for i=1:num_tri,
    fread(fid,3,'float32'); % normal coordinates, ignore
    vertices(i,:)=fread(fid,9,'float32'); %read vertex from triangles
    fread(fid,1,'uint16'); % color bytes
end
vertices = reshape(vertices',3,(3 * num_tri))';
faces = 1: (3 * num_tri);
faces = reshape(faces,3, num_tri)';
fclose(fid);
%end readStl()

