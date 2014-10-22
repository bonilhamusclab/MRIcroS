function intensities = balanceIntensities(intensities, balancePt)
%function intensities = balanceIntensities(intensities, balancePt)
%balancePt = .5 by default

if nargin<2
	balancePt = .5;
end

range = max(intensities) - min(intensities);
if range ~= 0 %normalize for range 0 (black) to 1 (white)
    intensities = (intensities - min(intensities)) / range;
    %next- color balance, so typical voxels are mid-gray
    %we could use a histogram
    % http://angeljohnsy.blogspot.com/2011/04/matlab-code-histogram-equalization.html?m=1
    %instead, since range is 0..1 we will use power function to make median = 0.5
    % to determine power exponent, we compute Logarithm to an arbitrary base http://en.wikipedia.org/wiki/Logarithm 
    mdn = median(intensities(:));
    pow = log(balancePt)/log(mdn);
    intensities = power(intensities, pow);
end
