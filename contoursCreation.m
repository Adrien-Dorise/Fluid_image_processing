function [ shape ] = contoursCreation( binaryImage,singlePlume )
% Creates a countour for the image in input. The image must be white with
% black objects. Put 0 as displayImage to avoid creating a plot.
%   inputs:binary image
%   outputs:plot of image and contours, contours coord matrix



h=fspecial('gaussian',5,5); %Creation of a Gaussian filter
bw=imfilter(binaryImage,h); %Application of the Gaussian filter
bw=imfill(~bw,'holes'); %Filling the holes in the picture
bw=~bw;
tempShape=bwboundaries(bw); %Creates countours in the picture, b countains the coord of each contour
tempShape=tempShape(2:end); %The first cell is the contour of the border around the picture, we don't need it

%Filtering of contour noises by size criteria
for i=1:length(tempShape)
    a=size(tempShape{i,1});
    if (a(1)<=80)
        tempShape{i,1}=[];  %Removing of unique dot (=noise)
    end
end
shape=cellfun('isempty',tempShape);   %We erase the empty matrix from the cell
tempShape(shape)=[];
shape=tempShape;



if length(shape)~=0
    %Filtering of the shapes created
    if singlePlume==1 || singlePlume==2
        %         Removing the noise using a size criteria
        sizeShape=0;
        for i=1:length(shape)
            if length(shape{i,1})>sizeShape
                sizeShape=length(shape{i,1});
            end
        end
        if length(shape{i,1})<=sizeShape/2 && length(shape{i,1})~=0
            shape{i,1}=[];
        end
    end
%     if singlePlume==1 %We keep only one shape to find a unique plume
%         len=[];
%         for i=1:length(shape)
%             len(i)=length(shape{i});
%         end
%         [maxi indice]=max(len);
%         shape=shape(indice);
%     end
    
    tempShape=cellfun('isempty',shape);   %We erase the empty matrix from the cell
    shape(tempShape)=[];
end
end
