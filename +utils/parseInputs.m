function varargout = parseInputs(args, defaults)
%function varargout = parseInputs(args, defaults)
%assumes any inputs specified as [], {}, or '' go to default
%
%examples
%   [a, b, c] = utils.parseInputs({'hi', '', 3},{'defaultHi', 2, 5});
%   a = 'hi', b = 2, and c = 3
%
%   [a, b, c] = utils.parseInputs({'hi'},{'defaultHi', 2, 5});
%   a = 'hi', b = 2, c = 5
    
varargout = defaults;
numArgs = length(args);
for i = 1:numArgs
    arg = args{i};
    if ~isempty(arg), varargout{i} = arg; end;
end