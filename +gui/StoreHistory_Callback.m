function StoreHistory_Callback(obj, ~)
%turn 'echo' mode on and off: allows GUI calls to be displayed in command window
v = guidata(obj);
v.echoCommands = ~v.echoCommands; %toggle echo mode on or off
guidata(v.hMainFigure,v);%store settings; %save new echo mode
%end StoreHistory_Callback()
%CRX - rest of commands not executed
%     if isfield(v, 'history')
%         
%        history = v.history;
%         
%        if ~isempty(history)
%             prompt = {'Enter variable name to assign history to:'};
%             title = 'Save History in Workspace';
%             lines = 1;
%             def = {'history'};
%             answer = inputdlg(prompt, title, lines, def);
%             assignin('base', answer{1}, history);
%        else
%            dispNoHistory();
%        end
%        
%     else
%         dispNoHistory();
%     end
%     
%     function dispNoHistory()
%         msgbox('No History recorded yet');
%     end
% end StoreHistory_Callback
