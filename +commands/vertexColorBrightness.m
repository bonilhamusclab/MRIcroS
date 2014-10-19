function vertexColorBrightness(v,layer, varargin)
%Use Perlin & Hoffert's bias function to adjust brightness (only for meshes with vertex colors)
% see http://blog.demofox.org/2012/09/24/bias-and-gain-are-your-friend/
% layer: mesh for adjustment
% brightness : 0.5 means no change, smaller value means darker
% alpha: opacity
% colormap: 'gray','autumn','cool'... or 1,2,3...
% colormin: in range 0..1, values dark than this value are displayed at this threshold
%MRIcroS('vertexColorBrightness', 1) %adjust Layer 1
% --- set a Layer's color and transparency

if isempty(v.surface(layer).vertexColors)
    fprintf('%s is for layers with vertex colors', mfilename);
    return;
end;
brightness = 0.5;
alpha = v.vprefs.colors(layer,4);
colorMap = v.surface(layer).colorMap;
colorMap = utils.colorTables(colorMap); %text name
colorMin = v.surface(layer).colorMin;
colorMin = utils.boundArray(colorMin,0,0.95);
if (length(varargin) >= 1) && isnumeric(varargin{1}), brightness = varargin{1}; end;
if (length(varargin) >= 2) && isnumeric(varargin{2}), alpha = varargin{2}; end;
if (length(varargin) >= 3) && isnumeric(varargin{3}), colorMap = varargin{3}; end;
if (length(varargin) >= 4) && isnumeric(varargin{4}), colorMin = varargin{4}; end;
if (length(varargin) < 1)
    if size(v.surface(layer).vertexColors,2) == 3 %RGB colors
        answer = inputdlg({'Brightness(0..1) 0.5=no change, less=darker','Alpha (0[transparent]..1[opaque])'},'Set opacity',1,{num2str(brightness), num2str(alpha)} );
        if isempty(answer), disp('options cancelled'); return; end;  
    else %if RGB else scalar 
        [~,str] = utils.colorTables(); %text name
        answer = inputdlg({'Brightness(0..1) 0.5=no change, less=darker',...
            'Alpha (0[transparent]..1[opaque])',['Colormap ' str],'ColorMin (0..0.95)'},...
            'Set opacity',1,{num2str(brightness), num2str(alpha),colorMap, num2str(colorMin)} );
        if isempty(answer), disp('options cancelled'); return; end;  
        colorMap = answer(3);
        colorMap = utils.colorTables(colorMap); %text name
        colorMin = utils.boundArray(str2double(answer(4)),0,0.95);
        v.surface(layer).colorMap = colorMap;
        v.surface(layer).colorMin = colorMin;    
    end
    brightness = str2double(answer(1));
    alpha = str2double(answer(2));
end;
v.vprefs.colors(layer,4) = alpha;
if (numel(v.surface(layer).vertexColors) > 0) && (brightness ~= 0.5)
    if (brightness >= 1), brightness = 1 - eps; end;
    if (brightness <= 0), brightness = eps; end;
    vc = v.surface(layer).vertexColors;
    v.surface(layer).vertexColors = (vc ./ ((((1.0 ./brightness) - 2.0) .*(1.0 - vc))+1.0));
end;
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end vertexColorBrightness()
