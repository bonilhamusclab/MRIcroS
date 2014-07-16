% --- read NIfTI header, Copyright (c) 2009, Jimmy Shen, 2-clause FreeBSD License
function [ dsr ] = read_header(fid)
dsr.hk   = header_key(fid);
dsr.dime = image_dimension(fid);
dsr.hist = data_history(fid);
if ~strcmp(dsr.hist.magic, 'n+1') && ~strcmp(dsr.hist.magic, 'ni1')
    dsr.hist.qform_code = 0;
    dsr.hist.sform_code = 0;
end
%end read_header()
