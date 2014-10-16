function closeAllItems(v)
%MRIcroS('closeAllItems');
commands.closeNodes(v);
v = guidata(v.hMainFigure); %bugfix 16-Oct-2014: closeNodes can change v
commands.closeTracks(v);
v = guidata(v.hMainFigure); %bugfix 16-Oct-2014: closeTracks can change v
commands.closeLayers(v);
%end closeAllItems()
