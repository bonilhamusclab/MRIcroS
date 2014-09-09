function [Hdr, Vol] = readNifti(filename)
%function [Hdr, Vol] = readNifti(filename)

Hdr = fileUtils.nifti.spm_vol_mimic(filename); %this call clones spm_vol without dependencies
Vol = fileUtils.nifti.spm_read_vols_mimic(Hdr);%this call clones spm_read_vols without dependencies

%Hdr = spm_vol(filename); % <- these are the actual SPM calls
%Vol = spm_read_vols(Hdr); % <- these are the actual SPM calls
