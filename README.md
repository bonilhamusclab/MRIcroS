##MATCRO Updates

Extending [Matcro](http://www.mccauslandcenter.sc.edu/CRNL/tools/surface-rendering-with-matlab) image viewing software.  

###Main Goal
Add ability to view [Trackvis TRK](http://www.trackvis.org/) files in Matcro.

###How To Use Track Layers
After starting Matlab

	`MATcro_DTI2('addTrack', trackFilePath)
	
or  
	
	`MATcro_DTI2('addTrack', trackFilePath, trackSampling, minFiberLen)
or
	MATcro_DTI2 % open in gui

`trackSampling` is used to specify 1/x sampling of the tracks to view. Default is 100, greatly speeds processing  
`minFiberLen` is used to specify the minimum fiber length that should be plotted. Default is 5.

###Installation
1.  `git clone https://github.com/joftheancientgermanspear/matcroUpdates.git`
2.  Set Matlab path to include the matcroUpdates project folder

###Special Thanks
1. [Chris Norden's Neuropsychology Lab](http://www.mccauslandcenter.sc.edu/CRNL/tools/surface-rendering-with-matlab) for making the [MATcro code](http://www.mccauslandcenter.sc.edu/CRNL/sw/surface/MATcro.m.txt) freely available  
2. John Colby for making the [trk_read.m](https://github.com/johncolby/along-tract-stats/blob/master/trk_read.m) freely available. Used for track header parsing.
3. NiBabel for [code](https://github.com/nipy/nibabel/blob/master/nibabel/orientations.py) that shows how to determine which voxel space the "vox to ras" header field is expecting.

###Note About Development
Still in early beta development, much work left to be performed
