function [Hdr] = spm_vol_mimic(filename)
%function [Hdr] = spm_vol_mimic(filename)
% --- load NIfTI header: mimics spm_vol without requiring SPM
[h, ~, fileprefix, machine] = fileUtils.nifti.hdr.load_nii_hdr(filename);
Hdr.dim = [h.dime.dim(2) h.dime.dim(3) h.dime.dim(4)];
if (h.hist.sform_code == 0) && (h.hist.qform_code == 0)
    fprintf('Warning: no spatial transform detected. Perhaps Analyze rather than NIfTI format');
    Hdr.mat = fileUtils.nifti.hdr.hdr2m(h.dime.dim,h.dime.pixdim );
elseif (h.hist.sform_code == 0) && (h.hist.qform_code > 0) %use qform Quaternion only if no sform
    Hdr.mat = fileUtils.nifti.hdr.quarternion.hdrQ2m(h.hist,h.dime.dim,h.dime.pixdim );
else %precedence: get spatial transform from matrix (sform)
    Hdr.mat = [h.hist.srow_x; h.hist.srow_y; h.hist.srow_z; 0 0 0 1];
    Hdr.mat = Hdr.mat*[eye(4,3) [-1 -1 -1 1]']; % mimics SPM: Matlab arrays indexed from 1 not 0 so translate one voxel
end;
if (machine == 'ieee-le')
	Hdr.dt = [h.dime.datatype 0];
else
	Hdr.dt = [h.dime.datatype 1];
end;
Hdr.pinfo = [h.dime.scl_slope; h.dime.scl_inter; h.dime.vox_offset];
if findstr('.hdr',filename) & strcmp(filename(end-3:end), '.hdr')
	Hdr.fname =  [fileprefix '.img']; %if file.hdr then set to file.img
else
	Hdr.fname =  filename;
end
Hdr.descrip = h.hist.descrip;
Hdr.n = [h.dime.dim(5) 1];
Hdr.private.hk = h.hk;
Hdr.private.dime = h.dime;
Hdr.private.hist = h.hist;
%end spm_vol_mimic()
