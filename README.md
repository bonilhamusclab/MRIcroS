##MRIcroS

###Main Goals
Extend [MATcro](http://www.mccauslandcenter.sc.edu/CRNL/tools/surface-rendering-with-matlab), which can already be used to view [NIFTi files](http://nifti.nimh.nih.gov/nifti-1/), to view the following file formats as well:

1.  [TrackVis TRK](http://www.trackvis.org/) files
2.  [Pial surface](http://brainsuite.org/processing/surfaceextraction/pial/) files
3.  NV surface files
4.  [BrainNet Node And Edge Connectome Files](http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910)

###How To View Tracks
After starting Matlab

	MRIcroS('addTrack', trackFilePath)
	
or  
	
	MRIcroS('addTrack', trackFilePath, trackSampling, minFiberLen)
or

	MRIcroS % open in GUI File => Add Tracks/Add Tracks with Options

`trackSampling` is used to specify 1/x sampling of the tracks to view. Default is 100, greatly speeds processing  
`minFiberLen` is used to specify the minimum fiber length that should be plotted. Default is 5.

###How to View Image Files (NiFTI, Pial, NV)
After starting Matlab

	MRIcroS('openLayer', pial_or_nifti_or_nv_file)
	
or

	MRIcroS('openLayer',file, threshold, reduce, smooth)

or

	MRIcroS % open in GUI, File => Add Image/Add Image With Options
	
####Pial/NV File Nuances
	
For Pial and NV files, only the 'reduce' parameter is used during rendering.
If the threshold param is NaN, a prompt will open to ask for the desired reduce value.   

	MRIcroS('openLayer',pial_or_nv_file) % a prompt will open requesting reduce

To pass in a value from the command line for reduce, specify reduce and threshold. Threshold can be any value but NaN (it won't be used anyway).

	reduce = .3;
	threshold = -1; %specific value not important, just can't be NaN
	MRIcroS('openLayer', pial_or_nv_file, threshold, reduce);


If reduce is not specified but threshold is, the default value of .1 for reduce will be used.

	MRIcroS('openLayer',pial_or_nv_file,-1); %same as specifying .1 for reduce

In other words, threshold acts as a flag to indicate if a prompt should come up for Pial/NV file loading. If it is NaN, it means show a prompt.

_Note: This admittedly is a hack used to interop with the GUI, it will be addressed shortly to be more intuitive_

###How to View BrainNet Edges and Nodes
After starting Matlab

	MRIcroS('addNodes', node_path, edge_path)
	
####Filtering Based on Node Radius or Edge Weight

	%only render nodes with radius greater than 2
	%will also remove edges not connected to a node after filtering
	nodeRadiusThreshold = 2; 
	%only render edges with weights greater than 2
	edgeWeightThreshold = 2;
	MRIcroS('addNodes', node_path, edge_path, nodeRadiusThreshold, edgeWeightThreshold)
	
	%to filter by edgeWeight but not node radius
	%set node radius threshold to -inf
	MRIcroS('addNodes', node_path, edge_path, -inf, edgeWeightThreshold)
	
or

	% open in GUI, File => Add BrainNet
	% will prompt for node and edge files
	% or
	% open GUI, File => Add BrainNet with options 
	% for filtering based on specified node radius and edge weight thresholds
	MRIcroS 
	
####View Nodes without Edges
	
To view just the nodes without the edges

	MRIcroS('addNodes', node_path, '');
	
	%view nodes with out edges, and filter for nodes greater than radius 3
	MRIcroS('addNodes', node_path, '', 3); 
	
####Change Color Map for node Colors
	

	%just load the nodes with no edges or filtering and hsv color scheme
	MRIcroS('addNodes', node_path, '', -inf, -inf, 'hsv');
Available color maps can be found [here](http://www.mathworks.com/help/matlab/ref/colormap.html)

	%Choose Load Nodes with Options
	MRIcroS

####Close all Nodes
	
To close all Nodes an edges 
_note: functionality not yet available for closing single Node/Edge connectome_

	MRIcroS('closeNodes');
	
	
####Support for Viewing effects of Weighted Edges Will be Part of Future Release


###More Information
More information can be found by

	help MRIcroS

or

	help commands.(press tab for autocompletion)

_All MRIcroS commands available from the prompt are scripts in the MRIcroS commands sub-package; in other words, the +commands sub-directory._


###Installation
1.  `git clone https://github.com/joftheancientgermanspear/MRIcroS.git`
2.  Set Matlab path to include the MRIcroS.git project folder

###Special Thanks
1. [Dr. Chris Rorden's Neuropsychology Lab](http://www.mccauslandcenter.sc.edu/CRNL/tools/surface-rendering-with-matlab) for writing the freely available [MATcro code](http://www.mccauslandcenter.sc.edu/CRNL/sw/surface/MATcro.m.txt) which is extended here   
2. John Colby for making the [trk_read.m](https://github.com/johncolby/along-tract-stats/blob/master/trk_read.m) freely available. Used for track header parsing.
3. NiBabel for [code](https://github.com/nipy/nibabel/blob/master/nibabel/orientations.py) that shows how to determine which voxel space the track file's header's "vox to ras matrix" is expecting when transforming tracks to RAS space.
4. Mingrui Xia of Beijing University for [BrainNet Viewer](http://www.nitrc.org/projects/bnv/). Code for parsing Node files derived from NI_Load function in BrainNew viewer's main file, BrainNet.m
5. [Dr. Bonilha of MUSC](http://academicdepartments.musc.edu/neurosciences/neurology/research/bonilha/our_team/current.html), and [Dr. Chris Rorden of USC Columbia](http://www.mccauslandcenter.sc.edu/CRNL/team), for providing guidance and sample code.

###Note About Development
Still in beta development, please report bugs to (email coming soon)
