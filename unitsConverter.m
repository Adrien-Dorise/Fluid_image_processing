% function [ cm ] = unitsConverter( image )
% %Convert pixel unit of a picture into cm if there is a ruler on this
% %picture
% this is not working...


clear all 
close all
plumeMovie = VideoReader('MVI_0244Trim.mp4');   %Video is converted in a matlab file
image=read(plumeMovie,1);




image=contourImage(image);
image=~image;
imshow(image);
b=contoursCreation(image);

hold on
for i=1:length(b)
    sizeCell=size(b{i});
    if (sizeCell(1)>40)&(sizeCell(1)<150)
    cont=b{i};
    plot(cont(:,2), cont(:,1),'r','LineWidth',2);
    difference=0;
    for j=1:length(b{i})
        for k=1:2
            for L=1:length(b{i+1})
              b{i}(j,k);
              temp=b{i}(j,k)-b{i+1}(L,k)
              if temp==difference
                  distance=temp
              end    
              difference=temp       
            end
        end
    end
    else
        b{i}=0;
    end
end


cm=0;

