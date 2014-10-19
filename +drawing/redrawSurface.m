function redrawSurface(v)
% --- creates renderings
v = guidata(v.hMainFigure);
drawing.removeSurfaces(v);
%delete(allchild(v.hAxes));%
set(v.hMainFigure,'CurrentAxes',v.hAxes)
set(0, 'CurrentFigure', v.hMainFigure);  %# for figures
if ( v.vprefs.backFaceLighting == 1)
    bf = 'reverselit';
else
    bf = 'unlit'; % 'reverselit';
end
surfaceCount = 0;
if(isfield(v, 'surface'))
    surfaceCount = length(v.surface);
end
v.surfacePatches = zeros(surfaceCount, 1);
for i=1:surfaceCount
    clr =  v.vprefs.colors ( (mod(i-1,length( v.vprefs.colors))+1) ,1:3);
    alph =  v.vprefs.colors (mod(i,length( v.vprefs.colors)),4);
    
    if ( v.vprefs.showEdges(i) == 1)
        ec = v.vprefs.edgeColors(i,1:3);
        ea = v.vprefs.edgeColors(i,4);
    else
        ec = 'none';
        ea = alph;
    end;
    %fprintf('%d %d %d\n',i, size(v.surface(i).vertexColors,1), size(v.surface(i).vertexColors,2));
    
    if size(v.surface(i).vertices,1) == size(v.surface(i).vertexColors,1) % - if provided edge color information
        %size(v.surface(i).vertexColors)
        if size(v.surface(i).vertexColors,2) == 3 %if vertexColors has 3 components Red/Green/Blue
            v.surfacePatches(i) = patch('vertices', v.surface(i).vertices,...
            'faces', v.surface(i).faces, 'facealpha',alph,...
            'FaceVertexCData',v.surface(i).vertexColors,...
            'facecolor','interp','facelighting','phong',...
            'edgecolor',ec,'edgealpha', ea, ...
            'BackFaceLighting',bf);
        else %if rgb color is scalar
            %v.surface(i)
            %if ~isfield(v.surface(i), 'colorMap')
            %    v.surface(i).colorMap = 6;
            %end
            
            clr = utils.magnitudesToColors(v.surface(i).vertexColors, v.surface(i).colorMap, v.surface(i).colorMin);
            %clr = colorSub(v.surface(i).vertexColors, v.surface(i).colorMap);
            %next line for gray scale, we can also use color scales...
            %v.surface(i).colorMap
            v.surfacePatches(i) = patch('vertices', v.surface(i).vertices,...
            'faces', v.surface(i).faces, 'facealpha',alph,...
            'FaceVertexCData',clr,...
            'facecolor','interp','facelighting','phong',...
            'edgecolor',ec,'edgealpha', ea, ...
            'BackFaceLighting',bf);             
        end
    else 
        v.surfacePatches(i) = patch('vertices', v.surface(i).vertices,...
        'faces', v.surface(i).faces, 'facealpha',alph,...
        'facecolor',clr,'facelighting','phong',...
        'edgecolor',ec,'edgealpha', ea, ...
        'BackFaceLighting',bf);
    end
end;
set(gca,'DataAspectRatio',[1 1 1])
axis vis3d off; %tight
h = rotate3d; 
set( h, 'ActionPostCallback', @gui.perspectiveChange_Callback); %called when user changes perspective
set(h,'Enable','on');
view( v.vprefs.az,  v.vprefs.el);
%v.vprefs.camLight = camlight( v.vprefs.azLight, v.vprefs.elLight);
if ~isempty(v.vprefs.camLight)
    delete(v.vprefs.camLight); % - delete previous lights!
end
v.vprefs.camLight = camlight( v.vprefs.azLight, v.vprefs.elLight);
material( v.vprefs.materialKaKdKsn);
guidata(v.hMainFigure,v);%store settings
%end redrawSurface()

