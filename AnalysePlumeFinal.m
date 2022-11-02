

%      \Post processing program to analyse plumes
% 	   \author  Adrien DORISE
% 	   \date    Date: 16/07/2018
% 	   \version 0.7





clear all
close all
%If not working: change parameters in filterRegions


% User parameters
wichVideo=1;  %Use to autmatically switch between known videos (1=Unique plume; 2=Rotational plume)
makeVideo=1;    %Put 1 if you want to save the video in the current folder
display=1;  %Put 0 for no windows on the screen, 1 if you want to display the video on the screen, 2 for the arrows only, 3 for the shape only
binaryTreshold=20;   %Adjust this parameter to modify the quality of the image processing
arrowSize=12;   %Size of the arrows
uniColor=0; %Put one if you want only one color, the arrow size will be decided automatically
squareRatio=8; %This parameters control the size of the picture division for the cross correlation function (small ratio means more precise grid but longuer calculation time)
framerate=50;   %Framerate of the video (Used tot determine the speed of the plumes)
units=920/87;    %Transformation of the pixels into mm [pixels/mm]
refreshRate=10; %Refresh rate of the infos (in fps)
beginning=11;  %First frame of the video to process (!!Cannot be lower than 20!!)
blackWhite=0; %Change the font of the binary background
firstFrame=0; %Put 1 if the first frame can be used as a reference
singlePlume=1; %Put 1 if the video is tere is only one plume on the video and 2 if ther is a limited number of plumes
firstPosition=880; %Altitude in pixels of the bottom plate where the plume start
filteringDelay = 10; %Number of frame to wait to have an average in order to remove zrong values and get a more accurate result 

% Initialisation
infos=0;
position=0;
lastInfos1=0;
counter=[];  %increase when a contour doesn't move, after a certain value, the contour is considered as noise
shape={};   %Contour cell
lastShape={};   %Contour cell of the previous frame
test={{[0 0]},{['none']},{['none']}};
testPos={['none']};
testDiam={['none']};
testHeight={['none']};
testSpeed={['none']};
normArrow=0;
coordArrows=[];
timer=refreshRate-1; %Timer is used with the refreshRate to update the infos
refreshTimer=1;
data={'Time(s)' 'Altitude(mm)' 'Velocity(mm/s)' 'Diameter(mm)' 'Heigth(mm)'};
filteredData={};
lastPosition=[];


%Creation of the frames and input of parameters depending on the chosen
%video
if wichVideo==1
    plumeMovie = VideoReader('MVI_0244Trim.mp4');   %Video is converted in a matlab file
    if (display~=0 || makeVideo==1) display=1; end
    binaryTreshold=12;   %Adjust this parameter to modify the quality of the image processing
    arrowSize=30;   %Size of the arrows
    squareRatio=16; %This parameters control the size of the picture division for the cross correlation function [pixels] (small ratio means more precise grid but longuer calculation time)
    framerate=25;   %Framerate of the video [image per second] (Used tot determine the speed of the plumes)
    units=464/40;    %Transformation of the pixels into mm [pixels/mm]
    beginning=100;  %First frame of the video to process
    blackWhite=0;
    firstFrame=1; %Put 1 if the first frame can be used as a reference
    singlePlume=1;
    
elseif wichVideo==2
    plumeMovie = VideoReader('45_25_1507201_1_enhance_realt.avi');   %Video is converted in a matlab file
    if (display~=0 || makeVideo==1) display=2; end
    binaryTreshold=20;   %Adjust this parameter to modify the quality of the image processing
    arrowSize=10;   %Size of the arrows
    squareRatio=32; %This parameters control the size of the picture division for the cross correlation function (small ratio means more precise grid but longuer calculation time)
    framerate=50;   %Framerate of the video (Used tot determine the speed of the plumes)
    units=920/150;    %Transformation of the pixels into mm [pixels/mm]
    beginning=20;  %First frame of the video to process
    blackWhite=1;
    firstFrame=0; %Put 1 if the first frame can be used as a reference
    singlePlume=0;
    
end

image=read(plumeMovie,1);
% units=unitsConverter(image);
background=read(plumeMovie,1); %Reference background
% greyBackground=rgb2gray(background);
% greyBackground=double(greyBackground)/255.0;
% greyBackground=im2bw(greyBackground);
% greyBackground=contourImage(greyBackground);

if makeVideo~=0
    video=VideoWriter('Plume.AVI');
    video.FrameRate=framerate;
    open(video);
    
else
    video=0;
end

refreshTimer=beginning;

%Beginning of the picture processing
for i=beginning:floor(plumeMovie.FrameRate*plumeMovie.Duration)
    i 
    time=i*1/framerate;
    image1=read(plumeMovie,i);  %The frame number i is taken from the video
    image2=read(plumeMovie,i-10);  %The frame taken in an other moment i from the video
    if firstFrame==1
        image3=background-image1;   %Comparaison of first frame and current
    else
        image3=image2-image1;   %Comparaison of frame i and frame i+1
    end
    image3=binary(image3,binaryTreshold,blackWhite);   %Tranformation into a binary picture using a treshold
    image3=filterRegions(image3);    %filtering the noise
    image3=~image3;     %Inverse the color of the backgroung and the front
    referenceImage=read(plumeMovie,i);    %Frame to display in the plot
    lastShape=shape;
    shape=contoursCreation(image3,singlePlume);    %Creation of the contour lines around the plume
    [correlation,coordArrows,normArrow,allCorrelation]=crossCorrelation(shape,lastShape,squareRatio,size(image3));
    [coordArrows,X,Y,normArrow]=velocityFieldFiltering(coordArrows);
    %         plotCorrelation(allCorrelation, 25, 5, 10); %Uncomment to plot a 3d figure of the correlation for a given square on the picture
    
    [shape,position,diameter, height,speed,testPos{i-beginning+2},testDiam{i-beginning+2},testHeight{i-beginning+2},testSpeed{i-beginning+2}]=getInfos(firstPosition, shape,normArrow,test,lastPosition, framerate,i-beginning+1,singlePlume, filteringDelay);  %Get the infos of the plumes
    test={testPos,testDiam,testHeight,testSpeed};  %Creation of tests inputs to plot infos curves
    [position, lastPosition(i-beginning+2), diameter, height, speed, test]=infosFiltering(test,i-beginning+1,framerate,units,position,diameter,height,speed,singlePlume);   %Get the infos of the plumes
    infos=[i,position,diameter,height,speed,time];
    if i==refreshTimer || i==beginning || i==beginning+1
        displayInfos=infos;
        displayArrows=coordArrows;
        displayArrows{5}=normArrow;
    end
    [video] = displayImage(video,referenceImage,shape,displayInfos,displayArrows,arrowSize,display,uniColor,makeVideo);
    data(i-beginning+2,1:5)={time infos(2) infos(5) infos(3) infos(4)};
    pause(1/framerate);
    
    if i==refreshTimer
        refreshTimer=round(refreshTimer+framerate/refreshRate);
    end
end

if makeVideo~=0
    close(video);
end
filteredData=dataFiltering(data,singlePlume,3);

'End of program'
