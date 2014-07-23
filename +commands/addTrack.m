function addTrack(v, filename, varargin)	
%MATcro('addTrack','dti.trk')
%MATcro('addTrack','dti.trk', 100)
%MATcro('addTrack','dti.trk', 50, 10)
%inputs: 
% 1) filename
% 2) fiber sampling space -1/x tracks will be sampled (default 1)
% 3) minimun fiber length (default 5)
	if (nargin < 2), return; end;
	inputs = cell2mat(varargin);
    if(length(inputs) == 1)
	  fileUtils.trk.addTrack(v, filename, inputs(1));
	elseif(length(inputs) == 2)
	  fileUtils.trk.addTrack(v, filename, inputs(1), inputs(2));
	else
	  fileUtils.trk.addTrack(v, filename);
    end
%end addTrack()
