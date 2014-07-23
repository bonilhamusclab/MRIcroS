##MATCRO Updates

Extending [Matcro](http://www.mccauslandcenter.sc.edu/CRNL/tools/surface-rendering-with-matlab) image viewing software.  

###Main Goal
Add ability to view [Travis TRK](http://www.trackvis.org/) files on a Matlab 3D plot. Including orientation and spacing.  

###How To Use Track Layers
	`MATcro_DTI2('addTrack', trackFilePath)
	
or  
	
	`MATcro_DTI2('addTrack', trackFilePath, trackSampling, minFiberLen)

`trackSampling` is used to specify 1/x sampling of the tracks to view. Default is 100, greatly speeds processing  
`minFiberLen` is used to specify the minimum fiber length that should be plotted. Default is 5.

###Installation
1.  `git clone https://github.com/joftheancientgermanspear/matcroUpdates.git`
2.  Set Matlab path to include the matcroUpdates project folder

###Special Thanks
1. [Chris Norden's Neuropsychology Lab](http://www.mccauslandcenter.sc.edu/CRNL/tools/surface-rendering-with-matlab) for making the [MATcro code](http://www.mccauslandcenter.sc.edu/CRNL/sw/surface/MATcro.m.txt) freely available  
2. John Colby for making the [trk_read.m](https://github.com/johncolby/along-tract-stats/blob/master/trk_read.m) freely available

###Note About Development
Still in early beta development, much work left to be performed