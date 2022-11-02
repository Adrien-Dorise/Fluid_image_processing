function [ newShape, position, diameter, height, speed, testPos, testDiam, testHeight, testSpeed] = getInfos2(firstPosition, shape, normArrow , test, lastPosition, frameRate, iteration, singlePlume, filteringDelay )
%Get the infos of the plume and remove irrevelant information
%Inputs: contour: a cell with the coordinates of the contour
%         test: Infos of the previous contours
%         framerate: Framerate of the video
%         iteration: Number of iteration already done before
%Outputs: newContour: The contour cell modified by the function
%         position: Current position of the plumes
%         diameter: Current diameter of the plumes
%         speed: Current speed of the plumes
%         testX: Vectors with the all the infos since the beginning of the video

% !!!!!!!!!!!!!!Gives infos for only 1 contour right now!!!!!!!!!!!!!!!!!
% !!!!!!!!!!!!!!Need to remove empty positions when removing not moving
% contours (line 45)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!Diameter just take the maximun distance: could be Y or
%X.Need to block Y and search by movig the X!!!!!!!!!!!!!!!!!!!!!



if length(shape)==0   %Verify if there is something to analyse
    diameter=0;
    position=0;
    height=0;
    speed=0;
    testPos=0;
    testDiam=0;
    testHeight=0;
    testSpeed=0;
else
    len=length(shape);    %Number of cells
    for i=1:len    %We are evaluating all the contour of the cell
        sizeShape=0;
        maxiPos(i)=100000;
        maxiHeight(i)=0;
        maxiDiam(i)=0;
        tempPos=min(shape{i,1});
        tempDiam=abs(max(shape{i,1}(:,2)-min(shape{i,1}(:,2))));  %Difference of left to right to have the diameter
        tempHeight=abs(max(shape{i,1}(:,1)-min(shape{i,1}(:,1))));  %Difference of down to up to have the height
        if maxiPos(i)>tempPos(1)
            maxiPos(i)=tempPos(1);
        end
        if maxiDiam(i)<tempDiam(1)
            maxiDiam(i)=tempDiam(1);
        end
        if maxiHeight(i)<tempHeight(1)
            maxiHeight(i)=tempHeight(1);
        end
        
        %Removing the noise using a movement criteria
        for j=1:length(test{1,1}{1,iteration}) %We are comparing all the last contours positions for the currents one
            if (test{1,1}{1,iteration}(1,1)~= 'none')   %Verifying that we are not in the first iteration
                diff=abs(maxiPos(i)-firstPosition-mean(test{1,1}{1,iteration}(1,j)));   %Difference between average position and current position
                if diff<50
                    shape{i,1}=[];    %Removing the static contour
                end
            end
        end
        
    end
    
    if singlePlume==1 || singlePlume==2
        %         Removing the noise using a size criteria
        
        for i=1:length(shape)
            if length(shape{i,1})>sizeShape
                sizeShape=length(shape{i,1});
            end
        end
        if length(shape{i,1})<=sizeShape/2 && length(shape{i,1})~=0
            shape{i,1}=[];
        end
    end
        
    
    %We erase the empty matrix from the variables
    newShape=cellfun('isempty',shape);
    shape(newShape)=[];
    position=abs(maxiPos-firstPosition);
    diameter=maxiDiam;
    height=maxiHeight;
    lastPos=max(test{1,1}{1,length(test{1,1})});
    
    testPos=position;
    testDiam=diameter;
    testHeight=height;
    
    if singlePlume == 1 && iteration > filteringDelay %We need to wait some frame to have a precise value for the speed
        lastPos=lastPosition(length(lastPosition)-filteringDelay);
        speed=abs(lastPos-max(position))/filteringDelay;
        
        %         iteration
        %         filteringDelay
        %         lastPos
        %         lastPosition
        %         position
        %         max(position)
        %         speed
        %
    elseif singlePlume ~= 1
        %Getting speed using correlation function
        nonZeros=find(normArrow);
        speed=mean(normArrow(nonZeros));
    else
        speed=-1;
    end
    testSpeed=speed;
    
end
newShape=shape;
end

