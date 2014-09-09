% --- load NIfTI header
function [hdr, filetype, fileprefix, machine] = load_nii_hdr(fileprefix)
% Copyright (c) 2009, Jimmy Shen, 2-clause FreeBSD License
if ~exist('fileprefix','var'),
  error('Usage: [hdr, filetype, fileprefix, machine] = load_nii_hdr(filename)');
end
machine = 'ieee-le';
new_ext = 0;
if findstr('.nii',fileprefix) & strcmp(fileprefix(end-3:end), '.nii')
  new_ext = 1;
  fileprefix(end-3:end)='';
end
if findstr('.hdr',fileprefix) & strcmp(fileprefix(end-3:end), '.hdr')
  fileprefix(end-3:end)='';
end
if findstr('.img',fileprefix) & strcmp(fileprefix(end-3:end), '.img')
  fileprefix(end-3:end)='';
end
if new_ext
  fn = sprintf('%s.nii',fileprefix);
  if ~exist(fn)
     msg = sprintf('Cannot find file "%s.nii".', fileprefix);
     error(msg);
  end
else
  fn = sprintf('%s.hdr',fileprefix);
  if ~exist(fn)
     msg = sprintf('Cannot find file "%s.hdr".', fileprefix);
     error(msg);
  end
end
fid = fopen(fn,'r',machine); 
if fid < 0,
  msg = sprintf('Cannot open file %s.',fn);
  error(msg);
else
  fseek(fid,0,'bof');
  if fread(fid,1,'int32') == 348
     hdr = fileUtils.nifti.hdr.read_header(fid);
     fclose(fid);
  else
     fclose(fid);
     %  first try reading the opposite endian to 'machine'
     switch machine,
     case 'ieee-le', machine = 'ieee-be';
     case 'ieee-be', machine = 'ieee-le';
     end
     fid = fopen(fn,'r',machine);
     if fid < 0,
        msg = sprintf('Cannot open file %s.',fn);
        error(msg);
     else
        fseek(fid,0,'bof');
        if fread(fid,1,'int32') ~= 348
           %  Now throw an error
           %
           msg = sprintf('File "%s" is corrupted.',fn);
           error(msg);
        end
        hdr = fileUtils.nifti.read_header(fid);
        fclose(fid);
     end
  end
end
if strcmp(hdr.hist.magic, 'n+1')
  filetype = 2;
elseif strcmp(hdr.hist.magic, 'ni1')
  filetype = 1;
else
  filetype = 0;
end
%end load_nii_hdr()
