function [ coordArrows,normX,normY,normArrow ] = velocityFieldFiltering( coordArrows )
%Filtering of the velocity field created by the crossCorrelation function

acceptability=4; %treshold for the filtering of each arrows
zeroLimit=0.01; %Limit of the norm when an arrow is considered close enough to zero
if length(coordArrows)~=0
    
    %Homogeneisation of the zeros values when the near values aren't zeros (means there is a displacement nearby)
     for i=2:length(coordArrows{3})-1 %We start at 2 and finish before the end to avoid matrix limit problems
            if coordArrows{3}(i)==0 && coordArrows{4}(i)==0
                if coordArrows{3}(i-1)>0.1 || coordArrows{3}(i+1)>0.1 || coordArrows{4}(i-1)>0.1 || coordArrows{4}(i+1)>0.1     
                    coordArrows{3}(i)=(coordArrows{3}(i-1)+coordArrows{3}(i+1))/2;
                    coordArrows{4}(i)=(coordArrows{4}(i-1)+coordArrows{4}(i+1))/2;
%                     corr_offsetX(i)=1000;
%                     corr_offsetY(i)=1000;
                else     %If there is no displacement nearby we want to display this value as a dot 
                    coordArrows{3}(i)=0;
                    coordArrows{4}(i)=0;
                end
            end
        end
    
    sizeVector=length(find(coordArrows{2}==coordArrows{2}(1))); %The Y coordinates of the arrow allow us to know the number of elements per lines   
    %Transformation of the X and Y vector norms into matrix 
    normX=vec2mat(coordArrows{3},sizeVector);
    normY=vec2mat(coordArrows{4},sizeVector);
    
    
    sizeMatrix=size(normX);
    for i=2:(sizeMatrix(1)-1) 
        for j=2:(sizeMatrix(2)-1)
            %Calculation of the average field around the current point
            averageX=(normX(i-1 ,j-1)+normX(i-1,j)+normX(i-1,j+1)+normX(i,j+1)+normX(i+1,j+1)+normX(i+1,j)+normX(i+1,j-1)+normX(i,j-1))/8;
            averageY=(normY(i-1 ,j-1)+normY(i-1,j)+normY(i-1,j+1)+normY(i,j+1)+normY(i+1,j+1)+normY(i+1,j)+normY(i+1,j-1)+normY(i,j-1))/8;
            if abs(normX(i,j))>=(averageX+averageX*acceptability)
                normX(i,j)=averageX;
            end
            
            if abs(normY(i,j))>=(averageY+averageY*acceptability)
                normY(i,j)=averageY;
            end            
        end
    end
%Transformation of the new coordinate matrix into the coord vectors as before
    normX(find(abs(normX)<=zeroLimit))=0;
    normX=normX';
    coordArrows{3}=normX(:)';
    normY(find(abs(normY)<=zeroLimit))=0;
    normY=normY';
    coordArrows{4}=normY(:)';
    normArrow=coordArrows{3}.^2+coordArrows{4}.^2;
else
    normX=0;
    normY=0;
end

