function saveBitmap(v,varargin)
% inputs: filename
%MRIcroS('saveBitmap',{'myPicture.png'});
% --- Save screenshot as bitmap image
if (length(varargin) < 1), return; end;
filename = char(varargin{1});
%saveas(v.hAxes, filename,'png'); %<- save as 150dpi
%Sets the units of your root object (screen) to pixels
% % set(0,'units','pixels')  
% % %Obtains this pixel information
% % pix = get(0,'screensize');
% % %Sets the units of your root object (screen) to inches
% % set(0,'units','inches')
% % %Obtains this inch information
% % inch = get(0,'screensize');
% % %Calculates the resolution (pixels per inch)
% % screendpi = pix(end)/inch(end);
print (v.hMainFigure, '-r600', '-dpng', filename); %<- save as 600dpi , '-noui'
%print (v.hMainFigure, sprintf('-r%03g',round(screendpi*2)), '-dpng', filename); %<- save as 600dpi , '-noui'
%end saveBitmap()
