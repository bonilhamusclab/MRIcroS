function CopyToClipboardMenu_Callback(obj, eventdata)
v=guidata(obj);
drawing.copyBitmap(v);
%end CopyToClipboardMenu_Callback()
