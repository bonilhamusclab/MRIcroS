function addTrack(v, varargin)	
	if (length(varargin) < 1), return; end;
	filename = char(varargin{1});
	fileUtils.trk.addTrack(v, filename)
%end addTrack()
