function ViewHistory_Callback(obj, ~)
    v = guidata(obj);
    if isfield(v, 'history')
        histories = v.history(:);
        
        if ~isempty(histories)
            historyFns = {histories(:).function};
            historyArgs = {histories(:).args};
            f = figure;
            uitable(f, [historyFns historyArgs], {'functions', 'args'});
        end
    end
end