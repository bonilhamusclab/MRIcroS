function addTrack(v, filename, varargin)	
%MRIcroS('addTrack','dti.trk')
%MRIcroS('addTrack','dti.trk', 'sampleSpacing', 100)
%MRIcroS('addTrack','dti.trk', 'sampleSpacing', 50, 'fiberLengthThreshold', 10)
%inputs: 
% 1) filename
% 2) sampleSpacing: 1/x tracks will be sampled (default 1)
% 3) fiberLengthThreshold: minimun fiber length before thresholding (default 5)
% --- Load trackvis fibers http://www.trackvis.org/docs/?subsect=fileformat

p = createInputParserSub();
parse(p, varargin{:});
sampleSpacing = p.Results.sampleSpacing;
fiberLengthThreshold = p.Results.fiberLengthThreshold;

if exist(filename, 'file') == 0
    tmp = fullfile ([fileparts(which('MRIcroS')) filesep '+examples'], filename);
    if exist(tmp, 'file') == 0
        fprintf('Unable to find "%s"\n',filename); 
        return; 
    end
    filename = tmp; %file exists is 'examples' directory
end;

addTrackSub(v, filename, sampleSpacing, fiberLengthThreshold);
%end addTrack()


function addTrackSub(v,filename, trackSpacing, fiber_len)
tic
    hold on
    [header,data] = fileUtils.trk.readTrack(filename);
	renderedFibers = drawing.trk.plotTrack(header, data, trackSpacing, fiber_len);

	hasTrack = isfield(v,'tracks');
	tracksIndex = 1;
	if(hasTrack), tracksIndex = tracksIndex + length(v.tracks); end
	v.tracks(tracksIndex).fibers = renderedFibers;
	v = drawing.removeDemoObjects(v);
	guidata(v.hMainFigure, v);
    
toc
%end addTrackSub()

function p = createInputParserSub()
p = inputParser;
p.addParameter('fiberLengthThreshold',5, @(x) validateattributes(x, {'numeric'},{'nonnegative', 'real'}));
p.addParameter('sampleSpacing',1, @(x) validateattributes(x, {'numeric'},{'positive','real','integer'}));