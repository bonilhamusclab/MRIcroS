function [brightness, alpha, colorMap, colorMin, cancelled] = vertexColorBrightnessPrompt(v, layer)
    
    brightness = 0.5;
    alpha = v.vprefs.colors(layer,4);
    colorMap = v.surface(layer).colorMap;
    colorMin = utils.boundArray(v.surface(layer).colorMin, 0, 0.95);
    
    cancelled = 0;
    
    function cancel()
        disp('options cancelled'); 
        cancelled = 1;
    end
    
    isRgb = size(v.surface(layer).vertexColors, 2) == 3;
    if isRgb
        answer = inputdlg({'Brightness(0..1) 0.5=no change, less=darker',...
            'Alpha (0[transparent]..1[opaque])'},...
            'Set opacity',1,...
            {num2str(brightness), num2str(alpha)} );
        if isempty(answer)
            cancel();
            return; 
        end;  
    else %scalar 
        [~,str] = utils.colorTables(); %text name
        answer = inputdlg({'Brightness(0..1) 0.5=no change, less=darker',...
            'Alpha (0[transparent]..1[opaque])',...
            ['Colormap ' str], 'ColorMin (0..0.95)'},...
            'Set opacity', 1,...
            {num2str(brightness), num2str(alpha), colorMap, num2str(colorMin)} );
        if isempty(answer)
            cancel();
            return; 
        end;  
        colorMap = utils.colorTables(answer(3)); %text name
        colorMin = utils.boundArray(str2double(answer(4)),0,0.95);    
    end
    brightness = str2double(answer(1));
    alpha = str2double(answer(2));
end