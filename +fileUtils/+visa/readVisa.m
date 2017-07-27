function [faces, vertices] = readVisa(filename)
% function [vertex,faces]=readVisa ( filename )
% Read BrainVisa mesh format
% See also fn_savemesh
%Based on  Thomas Deneux's fn_readmesh (Copyright 2005-2012)
%Adapted with by Chris Rorden 2015, original license maintained
% Copyright (c) 2012, Thomas Deneux
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

if nargin==0, 
    [files,pth] = uigetfile({'*.vtk;*.tri;*.mesh'},'Select the Image[s]');
    filename=fullfile(pth,files); 
end
if isempty(findstr(filename,'.')), filename = [filename '.vtk']; end


fid=fopen(filename,'r');

[p name ext] = fileparts(filename);
switch lower(ext(2:end))

case 'tri'
    
    nvertex=fscanf(fid,'- %d',1);
    vertex=fscanf(fid,'%f',6*nvertex);
    vertex=reshape(vertex,6,nvertex)';
    vertex=vertex(:,1:3);
    
    nfaces=fscanf(fid,'\n- %d',1);
    fscanf(fid,'%d',2);
    faces=fscanf(fid,'%d',3*nfaces);
    faces=reshape(faces,3,nfaces)';
    faces=faces(:,1:3)+1;
    
case 'mesh'
    
    [file_format, COUNT] = fread(fid, 5, 'uchar') ;
    
    if strcmp(char(file_format'),'ascii')
        
        fscanf(fid,'%s %i %i %i',4);
        nvertex= fscanf(fid,'%i',1);
        [vertex, COUNT] = fscanf(fid,' ( %f , %f , %f ) ',3*nvertex);
        vertex = reshape(vertex,3,nvertex)';
        
        fscanf(fid,'%i %i',2);
        nfaces= fscanf(fid,'%i',1);
        faces = fscanf(fid,' ( %i , %i , %i ) ',3*nfaces);
        faces = reshape(faces,3,nfaces)'+1;
                
    else
        
        [lbindian, COUNT] = fread(fid, 4, 'uchar') ;
        [arg_size, COUNT] = fread(fid, 1, 'uint32') ;
        [VOID, COUNT] = fread(fid, arg_size, 'uchar') ;
        [vertex_per_face, COUNT] = fread(fid, 1, 'uint32') ;
        [mesh_time, COUNT] = fread(fid, 1, 'uint32') ;
        
        [mesh_step, COUNT] = fread(fid, 1, 'uint32') ;
        [vertex_number, COUNT] = fread(fid, 1, 'uint32') ;
        vertex_number
        [vertex, COUNT] = fread(fid, 3*vertex_number, 'float32') ;
        [arg_size, COUNT] = fread(fid, 1, 'uint32') ;
        vertex=reshape(vertex,3,vertex_number)';
        
        [normal, COUNT] = fread(fid, 3*vertex_number, 'float32') ;
        [arg_size, COUNT] = fread(fid, 1, 'uint32') ;
        normal=reshape(normal, 3, vertex_number)' ;
        
        [faces_number, COUNT] = fread(fid, 1, 'uint32') ;
        [faces, COUNT] = fread(fid, vertex_per_face*faces_number, 'uint32') ;
        faces=reshape(faces,vertex_per_face,faces_number)' + 1;
        
    end
end

fclose(fid);
vertex(:,3) = -vertex(:,3);
vertices = vertex;

