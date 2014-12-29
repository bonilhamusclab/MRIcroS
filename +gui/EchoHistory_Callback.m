function EchoHistory_Callback(obj, ~)
    v = guidata(obj);
    if isfield(v, 'history')
        
       history = v.history;
        
       if ~isempty(history)
            echoCommandsSub(history);
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

function echoCommandsSub(history)
    fprintf('%%%%Command History%%%%\n')
    num_commands = length(history);
    for i = 1: num_commands
        command = 'MRIcroS(';
        inputs = history(i);
        inputs = inputs{:};
            for j = 1 : length(inputs)
               if ~isempty(inputs{j}) 
                   if ischar(inputs{j})
                       command = [command '''' inputs{j} ''',' ]; %#ok<AGROW>
                   else
                       command = [command sprintf('%g',inputs{j}) ',' ]; %#ok<AGROW>
                   end
               end
            end
        command(end) = ')'; %remove trailing comma with )
        fprintf('%s;\n', command); 
    end
    fprintf('%%%%%%%%\n')
end