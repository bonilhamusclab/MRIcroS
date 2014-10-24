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
    [clr, alph] = drawing.utils.currentLayerRGBA(i, v.vprefs.colors);
    
    if ( v.vprefs.showEdges(i) == 1)
        ec = v.vprefs.edgeColors(i,1:3);
        ea = v.vprefs.edgeColors(i,4);
    else
        ec = 'none';
        ea = alph;
    end;
    %fprintf('%d %d %d\n',i, size(v.surface(i).vertexColors,1), size(v.surface(i).vertexColors,2));
    
    if size(v.surface(i).vertices,1) == size(v.surface(i).vertexColors,1) % - if provided edge color information
        if size(v.surface(i).vertexColors,2) == 3 %if vertexColors has 3 components Red/Green/Blue
            v.surfacePatches(i) = patch('vertices', v.surface(i).vertices,...
            'faces', v.surface(i).faces, 'facealpha',alph,...
            'FaceVertexCData',v.surface(i).vertexColors,...
            'facecolor','interp','facelighting','phong',...
            'edgecolor',ec,'edgealpha', ea, ...
            'BackFaceLighting',bf);
        else %color is scalar
            %magnitudes at -1 beleived to be surface color
            projectedIndices = v.surface(i).vertexColors > -1;
            clrs = zeros(length(v.surface(i).vertexColors), 3);
            clrs(projectedIndices,:) = utils.magnitudesToColors(v.surface(i).vertexColors(projectedIndices), v.surface(i).colorMap, v.surface(i).colorMin);
            clrs(~projectedIndices, :) = repmat(clr,[sum(~projectedIndices) 1]);
            v.surfacePatches(i) = patch('vertices', v.surface(i).vertices,...
            'faces', v.surface(i).faces, 'facealpha',alph,...
            'FaceVertexCData',clrs,...
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
%v.vprefs.camLight = camlight( v.vprefs.azLight, v.vprefs.elLight);
v.vprefs.camLight = camlight( 0, 90);
material( v.vprefs.materialKaKdKsn);
guidata(v.hMainFigure,v);%store settings
%end redrawSurface()

