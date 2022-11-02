function [ correlation,coordArrow,norm,allCorrelation  ] = crossCorrelation( shape, lastShape, squarreRatio,sizePicture )
%This function gives the speed of the plume using the cross corelation
%function.Indeed, the distance between the last contour and the new one is
%calculate using the cross corelation formula
% inputs: Two contours from 2 differents frame
% output: velocity field

norm=0;
correlation=0;
allCorrelation={};
Xmax=sizePicture(1);
Ymax=sizePicture(2);
refImage=zeros(sizePicture(1),sizePicture(2));
lastRefImage=zeros(sizePicture(1),sizePicture(2));



currentGrid=1;
Xmin=1;
Ymin=1;

if (length(lastShape)~=0)&&(length(shape)~=0)   %We make sure the shape matrix is not empty
    for i=1:length(shape)
        shape1=shape{i};
        for i=1:length(shape1)
            refImage(abs(round(shape1(i,1))),round(shape1(i,2)))=1;
        end
        deltaX=abs(Xmax-Xmin);
        deltaY=abs(Ymax-Ymin);
        
    end
    maximum=0;
    
    %Creation of the matrix containing the shapes
    for i=1:length(lastShape)
        lastShape1=lastShape{i};
        for i=1:length(lastShape1)
            lastRefImage(abs(round(lastShape1(i,1))),round(lastShape1(i,2)))=1;
        end
    end
end
%Creation of the squarre grid
currentPosition=[0,0];
for i=0:squarreRatio:sizePicture(1)
    currentPosition=currentPosition+[1 0];
    currentPosition(2)=0;
    for j=0:squarreRatio:sizePicture(2)
        currentPosition=currentPosition+[0 1];
        Xmin=1;
        Ymin=1;
        Xmax=sizePicture(1);
        Ymax=sizePicture(2);
        
        if (Xmin+i+squarreRatio)<sizePicture(1) && (Ymin+j+squarreRatio)<sizePicture(2) %Verification that the arrows are not going out of the picture
            % Xmin=sizePicture(1)-i-squarreRatio;
            image=refImage(Xmin+i:Xmin+i+squarreRatio,Ymin+j:Ymin+j+squarreRatio);
            lastImage=lastRefImage(Xmin+i:Xmin+i+squarreRatio,Ymin+j:Ymin+j+squarreRatio);
            emptyImage=size(find(image));
            emptyLastImage=size(find(lastImage));
            
            Xpos(currentGrid)=round(i+squarreRatio/2)+Xmin; %We place the arrow in the middle of each grid
            Ypos(currentGrid)=round(j+squarreRatio/2)+Ymin;
            if (length(lastShape)~=0)&&(length(shape)~=0)
                if (emptyImage(1)==0) && (emptyLastImage(1)==0)   %If both image are empty,we do not do the correlation
                    corr_offsetX(currentGrid) = 0;
                    corr_offsetY(currentGrid) = 0;
                else
                    %Application of the correlation function
                    correlation = xcorr2(image,lastImage);
                    [max_cc, imax] = max(abs(correlation(:)));
                    [ypeak, xpeak] = ind2sub(size(correlation),imax(1));
                    corr_offsetX(currentGrid) = (xpeak-size(image,2));
                    corr_offsetY(currentGrid) = (ypeak-size(image,1));                    
                    allCorrelation{currentPosition(1),currentPosition(2)}=correlation;

                    %Removing of the wrongs values
                    if (corr_offsetY(currentGrid)==corr_offsetX(currentGrid))||(abs(corr_offsetX(currentGrid))>5)||(abs(corr_offsetY(currentGrid))>5)   %Need to change this line but for now a vector of X=Y is an error and arrows more than 10
                        corr_offsetY(currentGrid)=0;
                        corr_offsetX(currentGrid)=0;
                        
                    end
                    
                end
            else
                corr_offsetX(currentGrid)=0;
                corr_offsetY(currentGrid)=0;
            end
            currentGrid=currentGrid+1;
            
        end
        
    end
end
coordArrow={Ypos,Xpos,corr_offsetX,corr_offsetY};
norm(1,1:length(corr_offsetX))=sqrt(corr_offsetX(1,:).^2+corr_offsetY(1,:).^2);


end
