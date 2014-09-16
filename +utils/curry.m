function curriedFn = curry(fn, varargin)
%function curriedFn = curry(fn, varargin)
%   Origina Code Provided by Adam Bard in project: functools-for-matlab
%   https://github.com/adambard/functools-for-matlab/blob/master/%2Bfunctools/partial.m
%   fn = @(a,b) a^2 + b;
%   cFn = utils.curry(fn, 6);
%   square6(3) %39
    alwaysProvided = varargin;
    curriedFn = @(varargin) fn(alwaysProvided{:}, varargin{:});
end

