function addTrack(v, filename, trackSpacing)	
	if (nargin < 2), return; end;
	%filename = char(varargin{1});
	if (nargin < 3) 
	  trackSpacking = 1; 
	end
	fileUtils.trk.addTrack(v, filename, trackSpacing);
%end addTrack()
