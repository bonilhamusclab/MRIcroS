function AddNodes_Callback(promptForOpts, obj, ~)
%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910
	options =  ...
	{'*.node;', 'BrainNet Node files'; ...
	'*.*',					'All Files (*.*)'};
	title = 'Select a BrainNet Node (node) file';
    node_filename = loadFileDlgSub(options, title, 'load node cancelled');
	if (~node_filename), return; end;
    
    edge_filename = '';
    loadEdges = questdlg('load associated Edge file As well?',...
        'Edge File Question', ...
        'Yes', 'No', 'Yes');
    
    loadEdges = strcmp('Yes',loadEdges);
    
    if(loadEdges)

        options = ...
        {'*.edge;', 'BrainNet Edge files'; ...
        '*.*',					'All Files (*.*)'};
        title = 'Select a BrainNet Edge (edge) file';
        edge_filename = loadFileDlgSub(options, title, 'load edge cancelled');
        if (~edge_filename), edge_filename = ''; end;
    end
    
    v = guidata(obj);
    
    nodeRadiusT = -inf;
    edgeWeightT = -inf;
    nodeColorMap = 'jet';
    if(promptForOpts)
        nodeRadThreshMsg = 'Node radius threshold (specify -inf for no thresholding):';
        nodeAlphaMsg = 'Node alpha:';
        
        prompt = {nodeRadThreshMsg, nodeAlphaMsg};
        
        if(loadEdges)
            edgeWightThreshMsg = 'Edge Weight threshold (specify -inf for no thresholding):';
            edgeAlphaMsg = 'Edge alpha:';
            prompt = { nodeRadThreshMsg, nodeAlphaMsg, edgeWightThreshMsg, edgeAlphaMsg };
            opts = inputdlg(prompt, 'Thresholds', 1, {num2str(-inf), num2str(1), num2str(-inf), num2str(1)});
            nodeRadiusT = str2double(opts(1));
            nodeAlpha = str2double(opts(2));
            edgeWeightT = str2double(opts(3));
            edgeAlpha = str2double(opts(4));
        else
            opts = inputdlg(prompt, 'Thresholds', 1, {num2str(-inf)});
            nodeRadiusT = str2double(opts(1));
            nodeAlpha = str2double(opts(2));
        end
        
        nodeColorMap = gui.brainNet.promptNodeColorMap();
        
    end
    
    MRIcroS('addNodes', node_filename, edge_filename, ...
        nodeRadiusT, edgeWeightT, nodeColorMap);
    
    if(promptForOpts)
        MRIcroS('brainNetAlpha', '', nodeAlpha, edgeAlpha);
    end
	
	
%end AddNodes_Callback

function [filename, isCancelled] = loadFileDlgSub(dlgOptions, title, cancelMsg)
	[filename, pathname] = uigetfile(dlgOptions, title);
	isCancelled = ~filename;
	if (isCancelled), disp(cancelMsg); return; end
	filename=[pathname filename];
    
%end loadFileDlgSub
