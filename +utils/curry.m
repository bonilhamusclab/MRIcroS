function curriedFn = curry(fn, varargin)
%function curriedFn = curry(fn, varargin)
%   Original Code Provided by Adam Bard in project: functools-for-matlab
%   https://github.com/adambard/functools-for-matlab/blob/master/%2Bfunctools/partial.m
%   fn = @(a,b) a^2 + b;
%   square6ThanAddB = utils.curry(fn, 6);
%   square6ThanAddB(3) %39
    alwaysProvided = varargin;
    curriedFn = @(varargin) fn(alwaysProvided{:}, varargin{:});
end

