function installed = isGiftiInstalled()
	installed = (exist('gifti.m', 'file') == 2);
end