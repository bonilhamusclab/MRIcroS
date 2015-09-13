function [vertex,face] = readVtk(filename)
%   [vertex,face] = readVtk(filename);
%   'vertex' is a 'nb.vert x 3' array specifying the position of the vertices.
%   'face' is a 'nb.face x 3' array specifying the connectivity of the mesh.
%   Copyright (c) Mario Richtsfeld, distributed under BSD license
% http://www.mathworks.com/matlabcentral/fileexchange/5355-toolbox-graph/content/toolbox_graph/read_vtk.m
% http://www.ifb.ethz.ch/education/statisticalphysics/file-formats.pdf
% ftp://ftp.tuwien.ac.at/visual/vtk/www/FileFormats.pdf
%The VTK format supports a wide range of datasets, Chris Rorden modified
% this version to read some binary images and provide sensible error reporting 
% for unsupported variants of the VTK format
% --- read VTK format mesh
fid = fopen(filename,'r');
if( fid==-1 )
    error('Can''t open the VTK file %s',filename);
end
str = fgets(fid);   % -1 if eof, signature, e.g. "# vtk DataFile Version 3.0"
if ~strcmp(str(3:5), 'vtk')
    error('The file is not a valid VTK one.');    
end
% read header
str = fgets(fid); % notes, e.g. "vtk output ImageThreshold=53.0" 
formatStr = fgets(fid); % datatype, "BINARY" or "ASCII" 
isBinary = false;
if strcmpi(formatStr(1:6), 'BINARY')
    isBinary = true;
elseif ~strcmpi(formatStr(1:5), 'ASCII')
    error('Only able to read VTK images saved as BINARY or ASCII, not %s', formatStr);
end
kindStr = fgets(fid); % kind, e.g. "DATASET POLYDATA" or "DATASET STRUCTURED_ POINTS"
if isempty(strfind(upper(kindStr),'POLYDATA'))
    error('Only able to read VTK images saved as POLYDATA, not %s', kindStr);
end
vertStr = fgets(fid); % number of vertices, e.g. "POINTS 685462 float"
if isempty(strfind(upper(vertStr),'POINTS'))
    error('Expected header to report "POINTS", not %s', vertStr);
end
nvert = sscanf(vertStr,'%*s %d %*s', 1);
% read vertices
if isBinary
    cnt = 3*nvert;
    vtx = fread(fid, cnt, 'float32=>float32');
else
    [A,cnt] = fscanf(fid,'%f %f %f', 3*nvert);
    str = fgets(fid); %read EOLN for vertices
    if cnt~=3*nvert
        warning('Problem in reading vertices.');
    end
    A = reshape(A, 3, cnt/3);
    vertex = A;
end;
% read polygons
str = fgets(fid); %e.g. "POLYGONS 6 30" 
info = sscanf(str,'%c %*s %*s', 1);
if isBinary
    if(info ~= 'P')
        error('Only able to read binary VTK files with POLYGONS: %s', str); 
    end
    nface = sscanf(str,'%*s %d %*s', 1);
    cnt = sscanf(str,'%*s %*s %d', 1);
    if (cnt ~= (4 * nface))
       error('Only able to read VTK files with triangles: %s', str);
    end
    A = fread(fid, cnt, 'uint32=>uint32');
    if A(1) ~= 3 %not native endian!!!!
        %A = swapbytes( uint32(A));
        A = swapbytes(A);
        vtx = swapbytes(vtx);
    end
    if A(1) ~= 3 %not native endian!!!!
        error('This vtk file is borked');
    end
    A = reshape(A, 4, cnt/4);
    face = double(A(2:4,:)+1);
    
    vertex = double(vtx);
    vertex = reshape(vertex, 3, numel(vertex)/3);
    fclose(fid);
    %vertex %report vertices
    %face'-1 %report faces
    return;
    
end


if((info ~= 'P') && (info ~= 'V'))
    str = fgets(fid);    
    info = sscanf(str,'%c %*s %*s', 1);
end
if(info == 'P')
    nface = sscanf(str,'%*s %d %*s', 1);
    cnt = sscanf(str,'%*s %*s %d', 1);
    if (cnt ~= (4 * nface))
       error('Only able to read VTK files with triangles: %s', str);
    end
    [A,cnt] = fscanf(fid,'%d %d %d %d\n', 4*nface);
    if cnt~=4*nface
        warning('Problem in reading faces.');
    end
    A = reshape(A, 4, cnt/4);
    face = A(2:4,:)+1;
end
if(info ~= 'P')
    face = 0;
end
% read vertex indices
if(info == 'V')
    nv = sscanf(str,'%*s %d %*s', 1);
    [A,cnt] = fscanf(fid,'%d %d \n', 2*nv);
    if cnt~=2*nv
        warning('Problem in reading faces.');
    end
    A = reshape(A, 2, cnt/2);
    face = repmat(A(2,:)+1, 3, 1);
end
if((info ~= 'P') && (info ~= 'V'))
    face = 0;
end
fclose(fid);
%vertex %report vertices
%face'-1 %report faces
%end readVtk()
