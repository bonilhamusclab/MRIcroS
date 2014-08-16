function v = removeSurfaces(v)
%removeSurfaces remove the surfaces from main screen
%if the objects are on the screen
%otherwise performs no operation
%inputs
%	v: the handle to the GUI with the demo objects
%outputs
%	v: returns the handle with the background removed after updating guiData
if(isfield(v, 'surfacePatches'))
	delete(v.surfacePatches);
	v = rmfield(v,'surface');
	v = rmfield(v,'surfacePatches');
	v.vprefs.demoObjects = false;
	guidata(v.hMainFigure, v);
end
