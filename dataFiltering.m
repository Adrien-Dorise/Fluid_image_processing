function [ newData ] = DataFiltering( data, singlePlume, filteringDelay )
% Filter of the values contain in Data

len=length(data);
acceptability0=8; %First try for filtering
acceptability=0.1; %percentage of error acceptability
zeroNumber=20; %Number of value taken to see if ze are at the end of the video so each new value can be consider an error

if singlePlume==1 || singlePlume==2 %Case of single plume
    
    
    newData=data;
    tempData=data(2:len,1:5);
    averageAltitude=sum(cell2mat(tempData(find(cell2mat(data(2:end,2))),2)))/length(find(cell2mat(data(2:end,2))));
    averageVelocity=sum(cell2mat(tempData(find(cell2mat(data(2:end,3))),3)))/length(find(cell2mat(data(2:end,3))));
    averageDiameter=sum(cell2mat(tempData(find(cell2mat(data(2:end,4))),4)))/length(find(cell2mat(data(2:end,4))));
    averageHeigth=sum(cell2mat(tempData(find(cell2mat(data(2:end,5))),5)))/length(find(cell2mat(data(2:end,5))));
    for i=filteringDelay+1:len     %We first remove the big errors in the data matrix
        if (data{i,2}<averageAltitude-averageAltitude*acceptability0) || (data{i,2}>averageAltitude+averageAltitude*acceptability0) %We check the values to different from the average of all the values
            if i<len-zeroNumber
                if length(find(cell2mat(data(i-zeroNumber/2:i+zeroNumber/2,2))==0))>=zeroNumber/2 %We consider the value equal to zero if ther is to much zeros around the current value
                    newData{i,2}=0;
                end
            elseif i>=len-zeroNumber && length(find(cell2mat(data(len-zeroNumber:end,2))==0))>=zeroNumber/2
                newData{i,2}=0;
            else
                newData{i,2}=sum(cell2mat(data(i-filteringDelay:i-1,2)));
            end
        end
        if (data{i,3}<averageVelocity-averageVelocity*acceptability0) || (data{i,3}>averageVelocity+averageVelocity*acceptability0)
            if i<len-zeroNumber
                if length(find(cell2mat(data(i-zeroNumber/2:i+zeroNumber/2,3))==0))>=zeroNumber/2
                    newData{i,3}=0;
                end
            elseif i>=len-zeroNumber && length(find(cell2mat(data(len-zeroNumber:end,3))==0))>=zeroNumber/2
                newData{i,3}=0;
            else
                newData{i,3}=sum(cell2mat(data(i-filteringDelay:i-1,3)));
            end
        end
        if (data{i,4}<averageDiameter-averageDiameter*acceptability0) || (data{i,4}>averageDiameter+averageDiameter*acceptability0)
            if i<len-zeroNumber
                if length(find(cell2mat(data(i-zeroNumber/2:i+zeroNumber/2,2))==0))>=zeroNumber/2
                    newData{i,4}=0;
                end
            elseif i>=len-zeroNumber && length(find(cell2mat(data(len-zeroNumber:end,4))==0))>=zeroNumber/2
                newData{i,4}=0;
            else
                newData{i,4}=sum(cell2mat(data(i-filteringDelay:i-1)));
            end
        end
        if (data{i,5}<averageHeigth-averageHeigth*acceptability0) || (data{i,5}>averageHeigth+averageHeigth*acceptability0)
            if i<len-zeroNumber
                if length(find(cell2mat(data(i-zeroNumber/2:i+zeroNumber/2,2))==0))>=zeroNumber/2
                    newData{i,5}=0;
                end
            elseif i>=len-zeroNumber && length(find(cell2mat(data(len-zeroNumber:end,5))==0))>=zeroNumber/2
                newData{i,5}=0;
            else
                newData{i,5}=sum(cell2mat(data(i-filteringDelay:i-1,5)));
            end
        end
    end
    
    for i=2:len
        if i<=filteringDelay*2+1
            average=sum(cell2mat(newData(2:filteringDelay*2+2,1:5)))/(filteringDelay*2);
            average=average-cell2mat(newData(i,1:5))/(2*filteringDelay);
        elseif i>=len-filteringDelay*2
            average=sum(cell2mat(newData(len-filteringDelay*2:len,1:5)))/(filteringDelay*2);
            average=average-cell2mat(newData(i,1:5))/(2*filteringDelay);
        else
            average=sum(cell2mat(newData(i-filteringDelay:i+filteringDelay,1:5)))/(2*filteringDelay);
            average=average-cell2mat(newData(i,1:5))/(2*filteringDelay);
        end
        
        
        if (newData{i,2}<average(2)-average(2)*acceptability) || (newData{i,2}>average(2)+average(2)*acceptability)
            newData{i,2}=average(2);
        end
        if (newData{i,3}<average(3)-average(3)*acceptability) || (newData{i,3}>average(3)+average(3)*acceptability)
            newData{i,3}=average(3);
        end
        if (newData{i,4}<average(4)-average(4)*acceptability) || (newData{i,4}>average(4)+average(4)*acceptability)
            newData{i,4}=average(4);
        end
        if (newData{i,5}<average(5)-average(5)*acceptability) || (newData{i,5}>average(5)+average(5)*acceptability)
            newData{i,5}=average(5);
        end
    end
    
    
    
else %Case of rotational plume
    newData={'Time(s)','Velocity(mm/s)'};
    newData(2:len,1)=data(2:end,1);
    newData(2:len,2)=data(2:end,3);
    tempData=newData(2:end,1:2);    
    averageVelocity=sum(cell2mat(tempData(find(cell2mat(data(2:end,3))),2)))/length(find(cell2mat(data(2:end,3))));
    for i=filteringDelay+1:len     %We first remove the big errors in the data matrix
        if (data{i,2}<averageVelocity-averageVelocity*acceptability0) || (data{i,2}>averageVelocity+averageVelocity*acceptability0)
            if i<len-zeroNumber
                if length(find(cell2mat(data(i-zeroNumber/2:i+zeroNumber/2,2))==0))>=zeroNumber/2 %We consider the value equal to zero if ther is to much zeros around the current value
                    newData{i,2}=0;
                end
            elseif i>=len-zeroNumber && length(find(cell2mat(data(len-zeroNumber:end,2))==0))>=zeroNumber/2
                newData{i,2}=0;
            else
                newData{i,2}=sum(cell2mat(data(i-filteringDelay:i-1,2)));
            end
        end
    end
        for i=2:len
            if i<=filteringDelay*2+1
                average=sum(cell2mat(newData(2:filteringDelay*2+2,2)))/(filteringDelay*2);
                average=average-cell2mat(newData(i,2))/(2*filteringDelay);
            elseif i>=len-filteringDelay*2
                average=sum(cell2mat(newData(len-filteringDelay*2:len,2)))/(filteringDelay*2);
                average=average-cell2mat(newData(i,2))/(2*filteringDelay);
            else
                average=sum(cell2mat(newData(i-filteringDelay:i+filteringDelay,2)))/(2*filteringDelay);
                average=average-cell2mat(newData(i,2))/(2*filteringDelay);
            end
            if (newData{i,2}<average-average*acceptability) || (newData{i,2}>average+average*acceptability)
                newData{i,2}=average;
            end
        end
    end
end

