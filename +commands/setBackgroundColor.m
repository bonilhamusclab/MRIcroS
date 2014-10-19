function setBackgroundColor(v, newBgColor)	
%MRIcroS('setBackgroundColor', [0 1 0]) %change to blue
%MRIcroS('addNodes', 'red') %change to red

set(v.hMainFigure, 'color', newBgColor);
