function [ shape, position, diameter, height, speed ] = getPosition( shape, firstPosition, singlePlume )
%Give the position of the plume



if length(contour)==0   %Verify if there is something to analyse
    diameter=0;
    position=0;
    height=0;
    speed=0;
    testPos=0;
    testDiam=0;
    testHeight=0;
    testSpeed=0;
else
    len=length(contour);    %Number of cells
    maxiDiam=0;
    for i=1:len    %We are evaluating all the contour of the cell
        maxiPos(i)=100000;
        maxiHeight(i)=0;
        maxiDiam(i)=0;
        tempPos=min(contour{i,1});
        tempDiam=abs(max(contour{i,1}(:,2)-min(contour{i,1}(:,2))));  %Difference of left to right to have the diameter
        tempHeight=abs(max(contour{i,1}(:,1)-min(contour{i,1}(:,1))));  %Difference of down to up to have the height
        if maxiPos(i)>tempPos(1)
            maxiPos(i)=tempPos(1);
        end
        if maxiDiam<tempDiam(1)
            maxiDiam(i)=tempDiam(1);
        end
        if maxiHeight<tempHeight(1)
            tempHeight;
            maxiHeight(i)=tempHeight(1);
        end
        
        
        
        position=abs(maxiPos-firstPosition);
        diameter=maxiDiam;
        height=maxiHeight;
        lastPos=max(test{1,1}{1,length(test{1,1})});
        if singlePlume == 1
            speed=abs(lastPos-min(position));
        else
            %Getting speed using correlation function
            speed=mean(normArrow);
            
        end
    end
