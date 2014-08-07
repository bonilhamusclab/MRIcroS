function nextPtr = skipFibers(data, header, ptr, numOfFibersToSkip)
	pointDim = 3 + header.n_scalars;
	maxPtr = length(data);
	if(ptr > maxPtr)
		error('passed in pointer greater than maximum available');
	end
	while numOfFibersToSkip > 0
		nPoints = data(ptr);
		skipSpace = 1 + pointDim * nPoints + header.n_properties;
		ptr = ptr + skipSpace;
		if(ptr > maxPtr)
			break;
		end
		numOfFibersToSkip = numOfFibersToSkip -1;
	end
	nextPtr = ptr;
end
