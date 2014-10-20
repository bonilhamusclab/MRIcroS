function obj = emptyToDefaults(obj, varargin)
%function obj = emptyToDefaults(obj, varargin)
%varargin is the defaults

    numInputs = length(obj);
    
    for i = 1:numInputs
        val = obj{i};
        if isempty(val)
            obj{i} = varargin{i};
        end
    end
    
end