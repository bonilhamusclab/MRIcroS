function [vFig] = makeGui()
% --- Declare and create all the user interface objects
sz = [980 680]; % figure width, height in pixels
screensize = get(0,'ScreenSize');
margin = [ceil((screensize(3)-sz(1))/2) ceil((screensize(4)-sz(2))/2)];
v.hMainFigure = figure('MenuBar','none','Toolbar','none','HandleVisibility','on', ...
  'position',[margin(1), margin(2), sz(1), sz(2)], ...
    'Tag', mfilename,'Name', mfilename, 'NumberTitle','off', ...
 'Color', get(0, 'defaultuicontrolbackgroundcolor'));
set(v.hMainFigure,'Renderer','OpenGL')
v.hAxes = axes('Parent', v.hMainFigure,'HandleVisibility','on','Units', 'normalized','Position',[0.0 0.0 1 1]); %important: turn ON visibility
%menus...
v.hFileMenu = uimenu('Parent',v.hMainFigure,'HandleVisibility','callback','Label','File');
v.hAddMenu = uimenu('Parent',v.hFileMenu,'Label','Add image','HandleVisibility','callback', 'Callback', @gui.AddMenu_Callback);
v.hAddAdvMenu = uimenu('Parent',v.hFileMenu,'Label','Add image with options','HandleVisibility','callback', 'Callback', @gui.AddAdvMenu_Callback);
v.hCloseImagesMenu = uimenu('Parent',v.hFileMenu,'Label','Close image(s)','HandleVisibility','callback', 'Callback', @gui.CloseImagesMenu_Callback);
v.hAddTracksMenu = uimenu('Parent',v.hFileMenu,'Label','Add tracks','HandleVisibility','callback','Callback', @gui.AddTracks_Callback);
v.hCloseTracksMenu = uimenu('Parent',v.hFileMenu, 'Label','Close tracks', 'HandleVisibility', 'callback','Callback', @gui.CloseTracks_Callback);
v.hAddNodesMenu = uimenu('Parent',v.hFileMenu, 'Label','Add Nodes', 'HandleVisibility', 'callback', ...
    'Callback', utils.curry(@gui.AddNodes_Callback, 0));
v.hAddNodesWithOptsMenu = uimenu('Parent',v.hFileMenu, 'Label','Add Nodes with options', 'HandleVisibility', 'callback',...
    'Callback', utils.curry(@gui.AddNodes_Callback, 1));
v.hCloseNodesMenu = uimenu('Parent',v.hFileMenu, 'Label','Close Nodes', 'HandleVisibility', 'callback','Callback', @gui.CloseNodes_Callback);
v.hSaveBmpMenu = uimenu('Parent',v.hFileMenu,'Label','Save bitmap','HandleVisibility','callback', 'Callback', @gui.SaveBmpMenu_Callback);
v.hSaveMeshesMenu = uimenu('Parent',v.hFileMenu,'Label','Save mesh(es)','HandleVisibility','callback', 'Callback', @gui.SaveMeshesMenu_Callback);
v.closeAllItemsMenu = uimenu('Parent',v.hFileMenu, 'Label','Close All Items', 'HandleVisibility', 'callback','Callback', @gui.CloseAllItems_Callback);

v.hEditMenu = uimenu('Parent',v.hMainFigure,'HandleVisibility','callback','Label','Edit');
v.hCopyToClipboardMenu = uimenu('Parent',v.hEditMenu,'Label','Copy To Clipboard','HandleVisibility','callback','Callback', @gui.CopyToClipboardMenu_Callback);

v.hFunctionMenu = uimenu('Parent',v.hMainFigure,'HandleVisibility','callback','Label','Functions');
v.hToolbarMenu = uimenu('Parent',v.hFunctionMenu,'Label','Show/hide toolbar','HandleVisibility','callback','Callback', @gui.ToolbarMenu_Callback);
v.hLayerRgbaMenu = uimenu('Parent',v.hFunctionMenu,'Label','Color and transparency','HandleVisibility','callback','Callback', @gui.LayerRgba_Callback);
v.hShowWireFrameMenu = uimenu('Parent',v.hFunctionMenu,'Label','Show Wireframe','HandleVisibility','callback','Callback', @gui.ShowWireFrame_Callback);
v.hMaterialOptionsMenu = uimenu('Parent',v.hFunctionMenu,'Label','Surface material and lighting','HandleVisibility','callback','Callback', @gui.MaterialOptionsMenu_Callback);
v.hSimplifyMeshesMenu = uimenu('Parent',v.hFunctionMenu,'Label','Simplify mesh(es)','HandleVisibility','callback','Callback', @gui.SimplifyMeshesMenu_Callback);
v.hRotateToggleMenu = uimenu('Parent',v.hFunctionMenu,'Label','Rotate','HandleVisibility', 'callback', 'Callback', utils.curry(@gui.RotateToggle_Callback, 0));
v.hRotateToggleWithOptionsMenu = uimenu('Parent',v.hFunctionMenu,'Label','Rotate With Options','HandleVisibility', 'callback', 'Callback', utils.curry(@gui.RotateToggle_Callback, 1));
v.hChangeBgColorMenu = uimenu('Parent',v.hFunctionMenu, 'Label', 'Change Background Color', 'HandleVisibility', 'callback', 'Callback', @gui.ChangeBgColor_Callback);

v.hHelpMenu = uimenu('Parent',v.hMainFigure,'HandleVisibility','callback','Label','Help');
v.hAboutMenu = uimenu('Parent',v.hHelpMenu,'Label','About','HandleVisibility','callback','Callback', @gui.AboutMenu_Callback);


%load default simulated surfaces
[cubeFV, sphereFV] = createDemoObjects;
v.surface(1) = cubeFV;
v.surface(2) = sphereFV;
%viewing preferences - color, material, camera position, light position
v.vprefs.demoObjects = true; %denote simulated objects
v.vprefs.colors = [0.7 0.7 0.9 0.6; 1 0 0 0.7; 0 1 0 0.7; 0 0 1 0.7; 0.5 0.5 0 0.7; 0.5 0 0.5 0.7; 0 0.5 0.5 0.7]; %rgba for each layer
v.vprefs.edgeColors = zeros(size(v.vprefs.colors, 1), 3);
v.vprefs.showEdges = zeros(size(v.vprefs.colors, 1));
v.vprefs.materialKaKdKsn = [0.6 0.4 0.4 100.0];%ambient/diffuse/specular strength and specular exponent
v.vprefs.backFaceLighting = 1;
v.vprefs.azLight = 0; %light azimuth relative to camera
v.vprefs.elLight = 60; %light elevation relative to camera
v.vprefs.camLight = [];
v.vprefs.az = 45; %camera azimuth
v.vprefs.el = 10; %camera elevation
guidata(v.hMainFigure,v);%store settings
vFig = v.hMainFigure;
set(vFig,'name','MRIcroS');
drawing.redrawSurface(v);
%end makeGUI()
