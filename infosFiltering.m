function [ position,lastPos, diameter, height, speed, test ] = infosFiltering( test, iteration, framerate, units, position, diameter, height, speed, singlePlume )
%This function filter the infos taken with get infos and uses some criteria to get a better reliability of the results.
%Also, put the infos to the good units
%If proble; with this function, change the criteria values


averageTaken=10; % number of values taken to make an average and filter the datas

modification=0;
position=max(position);
diameter=max(diameter);
speed=max(speed);
height=max(height);
criteriaPos=100;
criteriaDiam=50;
criteriaHeight=50;
criteriaSpeed=50;
lastPos=position;

if length(test{1,1}) > averageTaken+1 %we do not consider the first, we need enough values to filter the wrong infos
    for i=1:averageTaken
        lastPosition(i)=max(test{1,1}{iteration-i});
        lastDiameter(i)=max(test{1,2}{iteration-i});
        lastHeight(i)=max(test{1,3}{iteration-i});
        lastSpeed(i)=max(test{1,4}{iteration-i});
    end
    
    if position-mean(lastPosition) >= criteriaPos %We consider the plume cannot move more than 100 pixels in average of last positions
        newValue1=find(lastPosition<=mean(lastPosition)+criteriaPos); %We find all the positions fitting our criteria
        newValue2=find(lastPosition()>=mean(lastPosition)-criteriaPos);
        newValue=intersect(newValue1,newValue2);
        if length(newValue)~=0
            position=lastPosition(newValue(1)); %We replace the wrong value by the latest good value.
            lastPos=position;
            modification=1;
        end
    end
    if modification == 1 && (singlePlume == 1 || singlePlume==2) && speed~=-1 %If the position changed we need to change the speed too
        newValue1=find(lastSpeed<=mean(lastSpeed)+criteriaHeight);
        newValue2=find(lastSpeed()>=mean(lastSpeed)-criteriaSpeed);
        newValue=intersect(newValue1,newValue2);
        if length(newValue)~=0
            speed=lastSpeed(newValue(1));;
        end
    end
    
    if diameter-mean(lastDiameter) >= criteriaDiam %We consider the plume cannot grow more than 50 pixels in one frame in average of last positions
        newValue1=find(lastDiameter<=mean(lastDiameter)+criteriaDiam); %We find all the positions fitting our criteria
        newValue2=find(lastDiameter()>=mean(lastDiameter)-criteriaDiam);
        newValue=intersect(newValue1,newValue2);
        if length(newValue)~=0
            diameter=lastDiameter(newValue(1)); %We replace the weong value by the latest good value.
        end
    end
    
    if height-mean(lastHeight) >= criteriaHeight %We consider the plume cannot grow more than 50 pixels in one frame in average of last positions
        newValue1=find(lastHeight<=mean(lastHeight)+criteriaHeight); %We find all the positions fitting our criteria
        newValue2=find(lastHeight()>=mean(lastHeight)-criteriaHeight);
        newValue=intersect(newValue1,newValue2);
        if length(newValue)~=0
            height=lastHeight(newValue(1)); %We replace the weong value by the latest good value.
        end
    end
    
    
end
position=position/units;
diameter=diameter/units;
height=height/units;
if speed~=-1 
    speed=speed*framerate/units;
end
end

