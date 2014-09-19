function AddBrainNet_Callback(promptForThresholds, obj, ~)
%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910
	options =  ...
	{'*.node;', 'BrainNet Node files'; ...
	'*.*',					'All Files (*.*)'};
	title = 'Select a BrainNet Node (node) file';
    node_filename = loadFileDlgSub(options, title, 'load node cancelled');
	if (~node_filename), return; end;

	options = ...
	{'*.edge;', 'BrainNet Edge files'; ...
	'*.*',					'All Files (*.*)'};
	title = 'Select a BrainNet Edge (edge) file';
    edge_filename = loadFileDlgSub(options, title, 'load edge cancelled');
	if (~edge_filename), return; end;
    
    v = guidata(obj);
    
    if(promptForThresholds)
        prompt = {'Node radius threshold (specify -inf for no thresholding):',...
            'Edge Weight threshold (specify -inf for no thresholding):'};
        opts = inputdlg(prompt, 'Node and Edge Options', 1, {num2str(-inf), num2str(-inf)});
        nodeRadiusT = str2double(opts(1));
        edgeWeightT = str2double(opts(2));
        commands.addBrainNet(v, node_filename, edge_filename, nodeRadiusT, edgeWeightT);
    else
        commands.addBrainNet(v, node_filename, edge_filename);
    end
	
	
%end AddBrainNet_Callback

function [filename, isCancelled] = loadFileDlgSub(dlgOptions, title, cancelMsg)
	[filename, pathname] = uigetfile(dlgOptions, title);
	isCancelled = ~filename;
	if (isCancelled), disp(cancelMsg); return; end
	filename=[pathname filename];
