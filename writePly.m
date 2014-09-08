% --- creates binary format ply file, e.g. for meshlab
function writePly(vertex,face,filename)
%for format details, see http://paulbourke.net/dataformats/ply/
[fid,Msg] = fopen(filename,'Wt');
if fid == -1, error(Msg); end;
[~,~,endian] = computer;
fprintf(fid,'ply\n');
if endian == 'L'
    fprintf(fid,'format binary_little_endian 1.0\n');
else
    fprintf(fid,'format binary_big_endian 1.0\n');    
end
fprintf(fid,'comment created by MATLAB writeply\n');
fprintf(fid,'element vertex %d\n',length(vertex));
fprintf(fid,'property float x\n');
fprintf(fid,'property float y\n');
fprintf(fid,'property float z\n');
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
fwrite(fid, vertex', 'single');
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
