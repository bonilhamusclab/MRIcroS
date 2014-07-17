% --- guess orientation: only use when neither sform or qform is available
function M = hdr2M(dim, pixdim)
%from SPM decode_qform0 Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging, GPL
n      = min(dim(1),3);
vox    = [pixdim(2:(n+1)) ones(1,3-n)];
x = (dim(2:4)+1)/2;
off     = -vox.*origin;
M       = [vox(1) 0 0 off(1) ; 0 vox(2) 0 off(2) ; 0 0 vox(3) off(3) ; 0 0 0 1];
%end hdr2M()
