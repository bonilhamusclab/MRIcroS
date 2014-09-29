function changeBgColor(v, newBgColor)	
%MRIcroS('changeBgColor', [0 1 0]) %change to blue
%MRIcroS('addNodes', 'red') %change to red

set(v.hMainFigure, 'color', newBgColor);