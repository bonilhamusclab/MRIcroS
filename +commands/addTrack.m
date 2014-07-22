function addTrack(v, filename, trackSpacing, fiber_len)	
%MATcro('addTrack','dti.trk')
%MATcro('addTrack','dti.trk', 100)
%MATcro('addTrack','dti.trk', 50, 10)
%inputs: 
% 1) filename
% 2) fiber sampling space -1/x tracks will be sampled (default 1)
% 3) minimun fiber length (default 5)
	if (nargin < 2), return; end;
	fileUtils.trk.addTrack(v, filename, trackSpacing, fiber_len);
%end addTrack()
