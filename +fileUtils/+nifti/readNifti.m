function [Hdr, Vol] = readNifti(filename)
%function [Hdr, Vol] = readNifti(filename)
%file can be unzipped nifti (.gz) or nifti (.nii)

[~, ~, ext] = fileparts(filename);

isTmpUnpackedGz = false;
if isGzExtSub(ext) 
    ungzname = fullfile(pathstr, name);
    if exist(ungzname, 'file') ~= 0
        fprintf('Warning: File exists named %s; will open in place of %s\n',ungzname, filename);
        filename = ungzname;
    else
        filename = char(gunzip(filename));
        isTmpUnpackedGz = true;
    end;
end;

Hdr = fileUtils.nifti.spm_vol_mimic(filename); %this call clones spm_vol without dependencies
Vol = fileUtils.nifti.spm_read_vols_mimic(Hdr);%this call clones spm_read_vols without dependencies

%Hdr = spm_vol(filename); % <- these are the actual SPM calls
%Vol = spm_read_vols(Hdr); % <- these are the actual SPM calls

if (isTmpUnpackedGz), delete(filename); end; %remove temporary uncompressed image


function isGz = isGzExtSub(fileExt)
	isGz = length(fileExt)==3  && min((fileExt=='.gz')==1);
