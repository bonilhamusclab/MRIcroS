function writeVtk(vertex,face,filename)
%function writeVtk(vertex,face,filename)
% --- save Face/Vertex data as VTK format file
[nF nFd] =size(face);
[nV nVd] =size(vertex);
if (nF <1) || (nV <3 || (nFd ~=3) || (nVd ~=3)), warning('Problem with writeVtk'); return; end; 
if nF > 1024 %binary takes less disk space - use for complex images.... 
    writeBinaryVtkSub(vertex,face,filename);
    return;
end
fid = fopen(filename, 'wt');
fprintf(fid, '# vtk DataFile Version 3.0\n');
fprintf(fid, 'Comment: created with MRIcroS\n');
fprintf(fid, 'ASCII\n');
fprintf(fid, 'DATASET POLYDATA\n');
fprintf(fid, 'POINTS %d float\n',nV);
fprintf(fid, '%.12g %.12g %.12g\n', vertex');
fprintf(fid, 'POLYGONS %d %d\n',nF, nF*(nFd+1));
fprintf(fid, '3 %d %d %d\n', (face-1)');
fclose(fid);
%end writeVtk()

function writeBinaryVtkSub(vertex,face,filename)
%write binary vtk file - we save as BIG ENDIAN since Mango prefers this
% also checked compatibility with Slicer
[nF nFd] =size(face);
[nV nVd] =size(vertex);
if (nF <1) || (nV <3 || (nFd ~=3) || (nVd ~=3)), warning('Problem with writeVtk'); return; end; 
fid = fopen(filename, 'wb');
fprintf(fid, '# vtk DataFile Version 3.0\n');
fprintf(fid, 'Comment: created with MRIcroS\n');
fprintf(fid, 'BINARY\n');
fprintf(fid, 'DATASET POLYDATA\n');
fprintf(fid, 'POINTS %d float\n',nV);
fwrite(fid, vertex', 'float32', 'ieee-be' );
fprintf(fid, 'POLYGONS %d %d\n',nF, nF*(nFd+1));
f3(1:nF) = 3;
fc = [f3' (face - 1)];
fwrite(fid, fc', 'uint32', 'ieee-be' );
fclose(fid);
%end writeBinaryVtkSub()
