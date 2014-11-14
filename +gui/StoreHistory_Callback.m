function StoreHistory_Callback(obj, ~)
    v = guidata(obj);
    if isfield(v, 'history')
        
       history = v.history;
        
       if ~isempty(history)
            prompt = {'Enter variable name to assign history to:'};
            title = 'Save History in Workspace';
            lines = 1;
            def = {'history'};
            answer = inputdlg(prompt, title, lines, def);
            assignin('base', answer{1}, history);
       else
           dispNoHistory();
       end
       
    else
        dispNoHistory();
    end
    
    function dispNoHistory()
        msgbox('No History recorded yet');
    end
end
