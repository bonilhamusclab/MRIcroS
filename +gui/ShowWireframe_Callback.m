function ShowWireframe_Callback(showOpts, obj, ~)
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

if(showOpts)
    rgb = uisetcolor( v.vprefs.edgeColors(layer,1:3),'select color');
    rgb = utils.boundArray(rgb, 0, 1);

    if length(rgb) == 1; 
        dispCancelMsgSub;
        return;
    end;
        
    alpha = inputdlg('Set alpha between 0 and 1', '1');
    alpha = str2double(alpha);
    
    if isempty(alpha)
        dispCancelMsgSub;
        return;
    end;
    
    MRIcroS('showWireframe', layer, rgb, alpha);

else
    
    MRIcroS('showWireframe', layer);
    
end

function dispCancelMsgSub
disp('show wireframe cancelled'); 
