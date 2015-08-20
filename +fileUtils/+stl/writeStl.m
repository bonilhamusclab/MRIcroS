function writeStl(vertices,faces,filename)
%Save mesh in STL format
% vertices : point coordinates (XYZ)
% faces : integer list mapping vertices to triangles
% filename : file to be saved
%Notes
%  https://en.wikipedia.org/wiki/STL_(file_format)
%  http://www.mathworks.com/matlabcentral/fileexchange/36770-stlwrite-write-binary-or-ascii-stl-file
%   Original idea adapted from surf2stl by Bill McDonald. Huge speed
%   improvements implemented by Oliver Woodford. Non-Delaunay triangulation
%   of quadrilateral surface courtesy of Kevin Moerman. FaceColor
%   implementation by Grant Lohsen.
% Author: Sven Holcombe, 11-24-11
% Create the facets

%Copyrights for Matlab Central Code
% stlwriteSub Copyright (c) 2015, Sven Holcombe
% floodFill3DSub Copyright (c) 2006,  F Dinath
% 
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

facets = single(vertices');
%The following line is similar to MeshLab's Filters/Normals/InvertFacesOrientation
%facets([1,3],:)=facets([3,1],:);
facets = reshape(facets(:,faces'), 3, 3, []);
% Compute their normals
V1 = squeeze(facets(:,2,:) - facets(:,1,:));
V2 = squeeze(facets(:,3,:) - facets(:,1,:));
normals = V1([2 3 1],:) .* V2([3 1 2],:) - V2([2 3 1],:) .* V1([3 1 2],:);
clear V1 V2
normals = bsxfun(@times, normals, 1 ./ sqrt(sum(normals .* normals, 1)));
facets = cat(2, reshape(normals, 3, 1, []), facets);
clear normals
fid = fopen(filename, 'w');
fprintf(fid, '%-80s', 'stlwrite from Sven Holcombe');             % Title
fwrite(fid, size(facets, 3), 'uint32');           % Number of facets
% Add one uint16(0) to the end of each facet using a typecasting trick
facets = reshape(typecast(facets(:), 'uint16'), 12*2, []);
% Set the last bit to 0 (default) or supplied RGB
facets(end+1,:) = 0;
fwrite(fid, facets, 'uint16');
% Close the file
fclose(fid);
fprintf('%s wrote %d facets\n',mfilename, size(facets, 2));
%end writeStl()