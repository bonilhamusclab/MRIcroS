function LayerRGBA_Callback(obj, ~)
% --- let user select layer, then set RGBA for that layer 
v=guidata(obj);
nlayer = length(v.surface);
if nlayer > 1
    answer = inputdlg({['Layer (1..' num2str(nlayer) ')']}, 'Enter layer to modify', 1,{'1'});
    if isempty(answer), disp('options cancelled'); return; end;
    layer = round(str2double(answer));
    layer = utils.boundArray(layer,1,nlayer);
else
    layer = 1;
end;
contrast = 0.5;
if numel(v.surface(layer).vertexColors) < 1 %objects with vertex colors ignore surface color
	rgb = uisetcolor( v.vprefs.colors(layer,1:3),'select color');
	v.vprefs.colors(layer,1:3) = utils.boundArray(rgb, 0, 1);
	answer = inputdlg({'Alpha (0[transparent]..1[opaque])'},'Set opacity',1,{num2str( v.vprefs.colors(layer,4))} );
	if isempty(answer), disp('options cancelled'); return; end;
else
	rgb = v.vprefs.colors(layer,1:3);
	answer = inputdlg({'Alpha (0[transparent]..1[opaque])','Contrast(0..1)'},'Set opacity',1,{num2str( v.vprefs.colors(layer,4)),num2str(contrast)} );
	if isempty(answer), disp('options cancelled'); return; end;
	contrast = str2double(answer(2));  
end
alpha = str2double(answer(1));
commands.layerRGBA(v, layer, 'r', rgb(1), 'g', rgb(2), 'b', rgb(3), 'a', alpha, 'contrast', contrast);
%end LayerRGBA_Callback()
