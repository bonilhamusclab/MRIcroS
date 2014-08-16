function v = removeSurfaces(v)
%removeSurfaces remove the surfaces from main screen
%if the objects are on the screen
%otherwise performs no operation
% note: this does not remove the 'surfacePatches' or 'surface' field
%inputs
%	v: the handle to the GUI with the demo objects
%outputs
%	v: returns the handle with the surfaces removed after updating guiData

if(isfield(v, 'surfacePatches'))
	delete(v.surfacePatches);
	guidata(v.hMainFigure, v);
end
