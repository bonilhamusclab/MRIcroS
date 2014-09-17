function closeBrainNets(v, ~)
%MATcro('closeBrainNets');
if isfield(v, 'brainNets')
	drawing.brainNet.dePlotBrainNets(v);
    v = rmfield(v, 'brainNets');
	guidata(v.hMainFigure, v);
end