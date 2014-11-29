function writePly(vertex,vertexColors,face,filename, alpha)
%for format details, see http://paulbourke.net/dataformats/ply/
% see also http://www.okino.com/conv/imp_ply.htm http://www.mathworks.com/matlabcentral/fx_files/5459/1/content/ply.htm
% vertex: Vx3 array with X,Y,Z coordinates of each vertex
% vertexColors: Vx0 (empty), Vx1 (scalar) or Vx3 (RGB) colors for each vertex
% face: Fx3 triangle list indexed from 1, e.g. 1,2,3 is triangle connecting first 3 vertices
% filename: name to save object
% alpha: (optional) if provided, sets transparency of vertex colors, range 0..1
% --- creates binary format ply file, e.g. for meshlab
 
[fid,Msg] = fopen(filename,'Wt');
if fid == -1, error(Msg); end;
[~,~,endian] = computer;
fprintf(fid,'ply\n');
if endian == 'L'
    fprintf(fid,'format binary_little_endian 1.0\n');
else
    fprintf(fid,'format binary_big_endian 1.0\n');    
end
fprintf(fid,'comment created by MATLAB writePly\n');
fprintf(fid,'element vertex %d\n',length(vertex));
fprintf(fid,'property float x\n');
fprintf(fid,'property float y\n');
fprintf(fid,'property float z\n');
if size(vertex,1) == size(vertexColors,1)
    fprintf(fid,'property uchar red\n');
    fprintf(fid,'property uchar green\n');
    fprintf(fid,'property uchar blue\n');
    fprintf(fid,'property uchar alpha\n');
end
fprintf(fid,'element face %d\n',length(face));
%nb: MeshLab does not support ushort, so we save as either short or uint
if (length(vertex) < (2^15))
    fprintf(fid,'property list uchar short vertex_indices\n'); 
else
    fprintf(fid,'property list uchar uint vertex_indices\n'); % <- 'int' to 'uint'
end;
fprintf(fid,'end_header\n');
fclose(fid);
%binary data 
[fid,Msg] = fopen(filename,'Ab');
if fid == -1, error(Msg); end;
if size(vertex,1) == size(vertexColors,1) %Save vertex+color: xyzrgb
    %the trick is vertices XYZ are saved as float32, and RGB as UINT8
    %(1) convert XYZ vertices into byte array with float32 precision
    vertex32 = single(vertex');
    vertex32 = typecast(vertex32(:), 'uint8');
    %vertex32 = reshape(vertex32,size(vertex,1), 12); %XYZ vertices, each 4 bytes
    vertex32 = reshape(vertex32,12,size(vertex,1)); %XYZ vertices, each 4 bytes
    %(2) convert colors into RGB colors into byte array with 8-bit precision
    clr8 = uint8(vertexColors * 255); %scale 0..1 to 0..255
    alpha8 = ones(size(clr8,1),1);
    if exist('alpha','var') 
    	alpha8(:) = alpha;
    end
    alpha8 = uint8(alpha8 * 255); 
    if size(vertexColors,2) == 1 
        clr8 = [clr8 clr8 clr8 alpha8]; %convert scalar to RGB, add alpha
    else
        clr8 = [clr8 alpha8]; %add alpha to RGB
    end
    clr8 = clr8';
    %(3) combine vertex and color information
    vertexClr = [vertex32; clr8]; %32-bits XYZ data, 8-bits RGBA    
    fwrite(fid, vertexClr, 'uint8');
else
    fwrite(fid, vertex', 'single');
end
if (length(vertex) < (2^15))
    %slow code - optimization not important for small datasets
    for i = 1:length(face)
        fwrite(fid, 3, 'uchar');
        fwrite(fid,round(face(i,:)-1),'int16' ); 
    end;
else
    face32 = uint32(face'-1);
    face32 = typecast(face32(:), 'uint8');
    %13 bytes per triangle, 1 byte for number of vertices (=3), and 4 bytes each of the 3 vertices
    face8 = uint8(0);
    face8(length(face)*13 , 1) = face8;
    face8(:) = 3; %all triangles have 3 vertices
    pos8 = 1; %skip first byte
    pos32 = 0;
    for i = 1:length(face)
        for p = 1:12
            face8(pos8+p) = face32(pos32+p);
        end;
        pos8 = pos8+13; 
        pos32 = pos32+12;
    end;
    fwrite(fid,face8);
end;
fclose(fid);
%end writePly()
