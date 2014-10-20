function unlessFn = unless(cond, fn)
    function theFunc(x)
        if cond(x)
        else
            fn(x);
        end
    end
    unlessFn = @theFunc;
end