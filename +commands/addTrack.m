function addTrack(v, filename, varargin)	
%MRIcroS('addTrack','dti.trk')
%MRIcroS('addTrack','dti.trk', 100)
%MRIcroS('addTrack','dti.trk', 50, 10)
%inputs: 
% 1) filename
% 2) fiber sampling space: 1/x tracks will be sampled (default 1)
% 3) minimun fiber length (default 5)
% --- Load trackvis fibers http://www.trackvis.org/docs/?subsect=fileformat

[filename, isFound] = fileUtils.isFileFound(v, filename);
if ~isFound
    fprintf('Unable to find "%s"\n',filename); 
    return; 
end;
if (nargin < 2), return; end;
trackSpacing = 100;
fiber_len = 5;
if (length(varargin) >= 1) && isnumeric(varargin{1}), trackSpacing = varargin{1}; end;
if (length(varargin) >= 2) && isnumeric(varargin{2}), fiber_len = varargin{2}; end;
hold on
[header,data] = fileUtils.trk.readTrack(filename);
renderedFibers = drawing.trk.plotTrack(header, data, trackSpacing, fiber_len);

hasTrack = isfield(v,'tracks');
tracksIndex = 1;
if(hasTrack), tracksIndex = tracksIndex + length(v.tracks); end
v.tracks(tracksIndex).fibers = renderedFibers;
guidata(v.hMainFigure, v);
drawing.removeDemoObjects(v);

%end addTrackSub()
