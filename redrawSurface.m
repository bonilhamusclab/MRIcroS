% --- creates renderings
function redrawSurface(v)
delete(allchild(v.hAxes));%
set(v.hMainFigure,'CurrentAxes',v.hAxes)
set(0, 'CurrentFigure', v.hMainFigure);  %# for figures
if ( v.vprefs.backFaceLighting == 1)
    bf = 'reverselit';
else
    bf = 'unlit'; % 'reverselit';
end
for i=1:length( v.surface)
    clr =  v.vprefs.colors ( (mod(i-1,length( v.vprefs.colors))+1) ,1:3);
    if ( v.vprefs.bgMode == 1) && ( i == 1)
        ec = 'black';
    else
        ec = 'none';
    end;
    alph =  v.vprefs.colors (mod(i,length( v.vprefs.colors)),4);
    patch('vertices', v.surface(i).vertices,'faces', v.surface(i).faces,...
        'edgecolor',ec,'BackFaceLighting',bf,...
        'facealpha',alph,'facecolor',clr,'facelighting','phong');
end;
set(gca,'DataAspectRatio',[1 1 1])
set(gcf,'Color',[1 1 1])
axis vis3d off; %tight
h = rotate3d; 
set( h, 'ActionPostCallback', @myPost_Callback); %called when user changes perspective
set(h,'Enable','on');
view( v.vprefs.az,  v.vprefs.el);
v.vprefs.camLight = camlight( v.vprefs.azLight, v.vprefs.elLight);
material( v.vprefs.materialKaKdKsn);
%light;
guidata(v.hMainFigure,v);%store settings
%end redrawSurface()
