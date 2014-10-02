function ShowWireframe_Callback(obj, ~)
v=guidata(obj);
nlayer = length(v.surface);
if nlayer > 1
    answer = inputdlg({['Layer (1..' num2str(nlayer) ')']}, 'Enter layer to modify', 1,{'1'});
    if isempty(answer), disp('show wireframe cancelled'); return; end;
    layer = round(str2double(answer));
    layer = utils.boundArray(layer,1,nlayer);
else
    layer = 1;
end; 

rgb = uisetcolor( v.vprefs.edgeColors(layer,1:3),'select color');
rgb = utils.boundArray(rgb, 0, 1);

if length(rgb) == 1; disp('show wireframe cancelled'); return; end;

commands.showWireframe(v, layer, rgb);