function is = isPial(filename)
%function is = isPial(filename)
%inputs
% filename : file to test
%notes:
% filenames often do not have '.pial' extension
% we can detect the file by reading the first 8 bytes for a magic signature
% http://www.grahamwideman.com/gw/brain/fs/surfacefileformats.htm 
is = fileUtils.isExt('.pial',filename);
if is, return; end;
if ~exist(filename,'file'), return; end;
fid = fopen(filename, 'rb', 'b') ;
magic = fread(fid, 1, 'int64') ;
fclose(fid);
is = (magic == -1771902246540); %3 byte signature + 'creat'
%end isPial()
