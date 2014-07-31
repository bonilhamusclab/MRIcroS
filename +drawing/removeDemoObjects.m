function removeDemoObjects(v)
%removeDemoObjects remove the demo objects from main screen
%if the objects are on the screen
%otherwise performs no operation
%inputs
%	h: the handle to the GUI with the demo objects
isBackground = v.vprefs.demoObjects;
if (isBackground) 
	delete(v.surfacePatches);
    v = rmfield(v,'surface');
	v = rmfield(v,'surfacePatches');
	v.vprefs.demoObjects = false;
end
guidata(v.hMainFigure, v);
