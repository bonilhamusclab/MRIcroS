function [faces, vertices] = readStl(fileName)
% function [faces, vertices] = readStl(fileName)
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
%WARNING STL does not record redundancy in vertices. This uses needless
%memory and hinders vertex smoothing. Lets reduce this: 
% http://www.mathworks.com/matlabcentral/fileexchange/29986-patch-slim--patchslim-m-
% Copyright (c) 2011, Francis Esmonde-White
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
[vnew, indexm, indexn] =  unique(vertices, 'rows'); %#ok<ASGLU>
faces = indexn(faces);
fprintf('Redundant vertices removed %d -> %d (%g)\n',  size(vertices,1), size(vnew,1), size(vnew,1)/size(vertices,1));
vertices = vnew;




%end readStl()

