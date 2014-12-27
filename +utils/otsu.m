function [thresh] = otsu(I)
% BSD license: http://www.mathworks.com/matlabcentral/fileexchange/26532-image-segmentation-using-otsu-thresholding
% Damien Garcia 2010/03 http://www.biomecardio.com/matlab/otsu.html
% --- threshold for converting continuous brightness to binary image using Otsu's method.
nbins = 256;
if (min(I(:)) == max(I(:)) ), disp('otsu error: no intensity variability'); thresh =min(I(:)); return; end; 
intercept = min(I(:)); %we will translate min-val to be zero
slope = (nbins-1)/ (max(I(:))-intercept); %we will scale images to range 0..(nbins-1)
%% Convert to 256 levels
I = round((I - intercept) * slope);
%% Probability distribution
[histo,pixval] = hist(I(:),256);
P = histo/sum(histo);
%% Zeroth- and first-order cumulative moments
w = cumsum(P);
mu = cumsum((1:nbins).*P);
sigma2B =(mu(end)*w(2:end-1)-mu(2:end-1)).^2./w(2:end-1)./(1-w(2:end-1));
[maxsig,k] = max(sigma2B);
thresh=    pixval(k+1);
if (thresh >= nbins), thresh = nbins-1; end;
thresh = thresh/slope + intercept;
%end otsu()
