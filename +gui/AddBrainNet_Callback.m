function AddBrainNet_Callback(obj, ~)
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
	commands.addBrainNet(v, node_filename, edge_filename);
%end AddBrainNet_Callback

function [filename, isCancelled] = loadFileDlgSub(dlgOptions, title, cancelMsg)
	[filename, pathname] = uigetfile(dlgOptions, title);
	isCancelled = ~filename;
	if (isCancelled), disp(cancelMsg); return; end
	filename=[pathname filename];
