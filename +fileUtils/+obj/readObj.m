function [faces, vertices] = readObj(fileName)
%function [faces, vertices] = readObj(fileName)
%inputs:
%	fileName: the Wavefront Object file to open
%outputs:
%	faces: face matrix where cols are xyz and each row is face
%	vertices: vertices matrix where cols are xyz and each row a vertix
%notes
% https://en.wikipedia.org/wiki/Wavefront_.obj_file

fid=fopen(fileName);
%first pass : count items
num_v=0;
num_f=0;
tline = fgets(fid);
while ischar(tline)
    A=strread(tline,'%s','delimiter',' ');
    if strcmpi(A(1),'v'), num_v = num_v + 1; end;
    if strcmpi(A(1),'f'), num_f = num_f + 1; end;
    tline = fgets(fid);
end
fclose(fid);
if (num_f < 1) || (num_v < 3), fprintf('Unable to read this file'); return; end;
%2nd pass : read items
fid=fopen(fileName);
num_v=0;
num_f=0;
vertices= zeros([num_v, 3]);
faces= zeros([num_f, 3]);
tline = fgets(fid);
while ischar(tline)
    A=strread(tline,'%s','delimiter',' ');
    if strcmpi(A(1),'v'), 
        num_v = num_v + 1;
        vertices(num_v, 1) = str2double(char(A(2)));
        vertices(num_v, 2) = str2double(char(A(3)));
        vertices(num_v, 3) = str2double(char(A(4)));
    end;
    if strcmpi(A(1),'f')
        num_f = num_f + 1;
        % we need to handle f v1/vt1/vn1 v2/vt2/vn2 v3/vt3/vn3
        A2=strread(char(A(2)),'%s','delimiter','/');
        A3=strread(char(A(3)),'%s','delimiter','/');
        A4=strread(char(A(4)),'%s','delimiter','/');
        faces(num_f, 1) = str2double(char(A2(1)));
        faces(num_f, 2) = str2double(char(A3(1)));
        faces(num_f, 3) = str2double(char(A4(1)));
    end;
    tline = fgets(fid);
end
fclose(fid);
%end readObj()