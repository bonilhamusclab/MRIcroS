function newFn = appendOutput(fn, appendedOutput)
%function newFn = appendOutput(fn, appendedOutput)
%whenever fn is invoked it will have the appended output output as well
%Useful if function parameter requires fn with certain number of outputs
%fn = @(a)a * 2;
%newFn = utils.appendOutput(fn, 3)
%[a, b] = newFn(3) % will return a = 6, b = 3
    newFn = @(varargin) appendOutputToInputs(appendedOutput, fn, varargin{:});
end

function varargout = appendOutputToInputs(appendedOutput, fn, varargin)
    [varargout{1:nargout-1}] = fn(varargin{:});
    varargout{length(varargout)+1} = appendedOutput; 
end