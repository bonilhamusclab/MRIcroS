% --- add an image as a new layer on top of previously opened images
function doOpenLayer(v,varargin)
%  filename, threshold(optional), reduce(optional), smooth(optional)
% Optional values only influence NIfTI volumes, not meshes (VTK, GIfTI)
%  nb: threshold=Inf for midrange, threshold=-Inf for otsu, threshold=NaN for dialog box
%MATcro('openLayer',{'cortex_5124.surf.gii'});
%MATcro('openLayer',{'attention.nii.gz'}); %midrange threshold
%MATcro('openLayer',{'attention.nii.gz',-Inf}); %Otsu's threshold
%MATcro('openLayer',{'attention.nii.gz'},3,0.05,0); %threshold >3
if (length(varargin) < 1), return; end;
thresh = Inf;
reduce = 0.25;
smooth = 0;
filename = char(varargin{1});
if (length(varargin) > 1), thresh = cell2mat(varargin(2)); end;
if (length(varargin) > 2), reduce = cell2mat(varargin(3)); end;
if (length(varargin) > 3), smooth = cell2mat(varargin(4)); end;
fileUtils.SelectFileToOpen(v,filename, thresh, reduce, smooth);
%end doOpenLayer()
