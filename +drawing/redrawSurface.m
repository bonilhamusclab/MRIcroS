function redrawSurface(v)
% --- creates renderings
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
    %v.surface(i)
    if ~isempty(v.surface(i).vertexColors)
        v.surfacePatches(i) = patch('vertices', v.surface(i).vertices,...
        'faces', v.surface(i).faces, 'facealpha',alph,...
        'FaceVertexCData',v.surface(i).vertexColors,...
        'facecolor','interp','facelighting','phong',...
        'edgecolor',ec,'edgealpha', ea, ...
        'BackFaceLighting',bf);        
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
v.vprefs.camLight = camlight( v.vprefs.azLight, v.vprefs.elLight);
material( v.vprefs.materialKaKdKsn);
%light;
guidata(v.hMainFigure,v);%store settings
%end redrawSurface()
