function ToolbarMenu_Callback(obj, eventdata)
% --- show/hide figure toolbar
if strcmpi(get(gcf, 'Toolbar'),'none')
    set(gcf,  'Toolbar', 'figure');
else
    set(gcf,  'Toolbar', 'none');
end
%end ToolbarMenu_Callback()
