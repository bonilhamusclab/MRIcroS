function AddNodes_Callback(promptForThresholds, obj, ~)
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
    if(promptForThresholds)
        nodeRadThreshMsg = 'Node radius threshold (specify -inf for no thresholding):';
        
        prompt = {nodeRadThreshMsg};
        
        if(loadEdges)
            edgeWightThreshMsg = 'Edge Weight threshold (specify -inf for no thresholding):';
            prompt = { nodeRadThreshMsg, edgeWightThreshMsg };
            opts = inputdlg(prompt, 'Thresholds', 1, {num2str(-inf), num2str(-inf)});
            nodeRadiusT = str2double(opts(1));
            edgeWeightT = str2double(opts(2));
        else
            opts = inputdlg(prompt, 'Thresholds', 1, {num2str(-inf)});
            nodeRadiusT = str2double(opts(1));
        end
        
        nodeColorMap = gui.brainNet.promptNodeColorMap();
        
    end
    
    commands.addNodes(v, node_filename, edge_filename, ...
        nodeRadiusT, edgeWeightT, nodeColorMap); 
	
	
%end AddNodes_Callback

function [filename, isCancelled] = loadFileDlgSub(dlgOptions, title, cancelMsg)
	[filename, pathname] = uigetfile(dlgOptions, title);
	isCancelled = ~filename;
	if (isCancelled), disp(cancelMsg); return; end
	filename=[pathname filename];
    
%end loadFileDlgSub