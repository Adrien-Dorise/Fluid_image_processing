function [ contour, matrixContour ] = contourAverage( contour, background )
%Change the contours by doing an avergage of the different points to create a line
%Improvement: Remove for condition and find if a shape is different to put it in a different part of the cell 

treshold=50; %Filtering of the contours
    
    matrixContour=logical(zeros(length(background(:,1)),length(background(1,:))));

    for i=1:length(contour) %We create a matrix as the same size as the picture and put the value at 1 depending on the coordinates given in the contour cell
        for j=1:length(contour{i})
        matrixContour(contour{i}(j,1),contour{i}(j,2))=1;
        end
    end



    for i=1:size(matrixContour,2)   %We filter the shapes to differentiate the contours. We lock the Y and look the X
        for j=1:size(matrixContour,1) 
            if matrixContour(j,i)==1
                for k=j+1:j+treshold
                    if (matrixContour(k,i)==1)
                       matrixContour(k,i)=0;
                    end
                end
            end
        end
    end
    
    [i,j]=find(matrixContour);  %If there is a big gap between 2 Y value, we remove the value
    cellNumber=0;
    for k=2:length(i)
        if abs(i(k)-i(k-1))>=40
          i(k)=i(k-1);
          j(k)=j(k-1);
        end
    end
    contour={};
    contour{1}=[i,j];   %We put the coordinates inside the contour cell to plot the shape of the plume

