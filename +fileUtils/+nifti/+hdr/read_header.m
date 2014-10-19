function [ dsr ] = read_header(fid)
% --- read NIfTI header, Copyright (c) 2009, Jimmy Shen, 2-clause FreeBSD License
dsr.hk   = fileUtils.nifti.hdr.header_key(fid);
dsr.dime = fileUtils.nifti.hdr.image_dimension(fid);
dsr.hist = fileUtils.nifti.hdr.data_history(fid);
if ~strcmp(dsr.hist.magic, 'n+1') && ~strcmp(dsr.hist.magic, 'ni1')
    dsr.hist.qform_code = 0;
    dsr.hist.sform_code = 0;
end
%end read_header()
