function closeNodes(v, ~)
%MRIcroS('closeNodes');
%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910

v = guidata(v.hMainFigure);
if isfield(v, 'brainNets')
	drawing.brainNet.dePlotBrainNets(v);
    v = rmfield(v, 'brainNets');
	guidata(v.hMainFigure, v);
end
