function addTrack(v, filename, varargin)	
%MRIcroS('addTrack','dti.trk')
%MRIcroS('addTrack','dti.trk', 100)
%MRIcroS('addTrack','dti.trk', 50, 10)
%inputs: 
% 1) filename
%   Optional:
% 2) trackSpacing: 1/x tracks will be sampled (default 100)
% 3) fiberLengthThreshold: minimun fiber length before thresholding (default 5)
% --- Load trackvis fibers http://www.trackvis.org/docs/?subsect=fileformat

[filename, isFound] = fileUtils.isFileFound(v, filename);
if ~isFound
    fprintf('Unable to find "%s"\n',filename); 
    return; 
end;

inputs = parseInputParamsSub(varargin);

trackSpacing = inputs.trackSpacing;
fiberLen = inputs.fiberLengthThreshold;

hold on
[header,data] = fileUtils.trk.readTrack(filename);
renderedFibers = drawing.trk.plotTrack(header, data, trackSpacing, fiberLen);

hasTrack = isfield(v,'tracks');
tracksIndex = 1;
if(hasTrack), tracksIndex = tracksIndex + length(v.tracks); end
v.tracks(tracksIndex).fibers = renderedFibers;
guidata(v.hMainFigure, v);
drawing.removeDemoObjects(v);

%end addTrackSub()

function inputParams = parseInputParamsSub(args)
p = inputParser;
d.fiberLengthThreshold = 5; d.trackSpacing = 100;

p.addOptional('trackSpacing',1, ...
    @(x) validateattributes(x, {'numeric'},{'positive','real','integer'}));
p.addOptional('fiberLengthThreshold',5, ...
    @(x) validateattributes(x, {'numeric'},{'nonnegative', 'real'}));

p = utils.stringSafeParse(p, args, fieldnames(d), d.fiberLengthThreshold, d.trackSpacing);

inputParams = p.Results;