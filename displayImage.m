function [ video ] = displayImage( video, image, contour, infos,coordArrow,arrowSize, display, uniColor, makeVideo )
%Display the images and save them into a video if asked



if display~=0 || makeVideo==1
    
    
    arrowCoeff=2;
    %Adding the scale colors
    UniColor=0; %Put 1 if you want only one color
    yellow=[1 1 0];
    blue=[0 0 1];
    orange=[1 0.5 0];
    red=[1 0 0];
    pointColor='blue';
    textColor=[0 1 0];
    
    if makeVideo==1
        fig=figure('visible','off');
    end
    
    imshow(image)
    hold on
    warning('off', 'Images:initSize:adjustingMag'); %Remove the warning due to figure scale and improve the quality of the figure picture
    
    
    if (display==1 || display==2)
        if length(coordArrow{1})~=0
            
            %Displaying of a point when the norm is zero
            zeroX=find(coordArrow{3}==0);
            zeroY=find(coordArrow{4}==0);
            coordPoints=intersect(zeroX,zeroY);
            plot(coordArrow{1}(coordPoints),coordArrow{2}(coordPoints),'.','Color', pointColor);
            
            if uniColor==1
                arrows=quiver(coordArrow{1},coordArrow{2},coordArrow{3},coordArrow{4});
                arrows.Color=[1 0 0];
                arrows.AutoScaleFactor=1;
                arrows.LineWidth=arrowCoeff;
                arrows.MaxHeadSize=1;
            else
                
                
                %Definition of the color limits for the arrows
                maxi=max(abs(coordArrow{5}));
                limitArrow1=maxi/8;
                limitArrow2=maxi/4;
                limitArrow3=maxi/2;
                
                %Creation of the arrows object depending of thir norm
                arrows1={[coordArrow{1}(find(abs(coordArrow{5})<limitArrow1))] [coordArrow{2}(find(abs(coordArrow{5})<limitArrow1))] [coordArrow{3}(find(abs(coordArrow{5})<limitArrow1))] [coordArrow{4}(find(abs(coordArrow{5})<limitArrow1))]};
                arrows2={[coordArrow{1}(find(abs(coordArrow{5})<limitArrow2 & abs(coordArrow{5})>=limitArrow1))] [coordArrow{2}(find(abs(coordArrow{5})<limitArrow2 & abs(coordArrow{5})>=limitArrow1))] [coordArrow{3}(find(abs(coordArrow{5})<limitArrow2 & abs(coordArrow{5})>=limitArrow1))] [coordArrow{4}(find(abs(coordArrow{5})<limitArrow2 & abs(coordArrow{5})>=limitArrow1))]};
                arrows3={[coordArrow{1}(find(abs(coordArrow{5})<limitArrow3 & abs(coordArrow{5})>=limitArrow2))] [coordArrow{2}(find(abs(coordArrow{5})<limitArrow3 & abs(coordArrow{5})>=limitArrow2))] [coordArrow{3}(find(abs(coordArrow{5})<limitArrow3 & abs(coordArrow{5})>=limitArrow2))] [coordArrow{4}(find(abs(coordArrow{5})<limitArrow3 & abs(coordArrow{5})>=limitArrow2))]};
                arrows4={[coordArrow{1}(find(abs(coordArrow{5})>=limitArrow3))] [coordArrow{2}(find(abs(coordArrow{5})>=limitArrow3))] [coordArrow{3}(find(abs(coordArrow{5})>=limitArrow3))] [coordArrow{4}(find(abs(coordArrow{5})>=limitArrow3))]};
                
                %Color affectation
                if length(arrows1{1})~=0
                    velocityArrows1=quiver(arrows1{1},arrows1{2},arrows1{3}*arrowSize,arrows1{4}*arrowSize);
                    velocityArrows1.AutoScale='off';
                    velocityArrows1.Color=blue;
                    velocityArrows1.AutoScaleFactor=1;
                    velocityArrows1.LineWidth=arrowCoeff;
                    velocityArrows1.MaxHeadSize=1;
                end
                
                if length(arrows2{1})~=0
                    velocityArrows2=quiver(arrows2{1},arrows2{2},arrows2{3}*arrowSize,arrows2{4}*arrowSize);
                    velocityArrows2.AutoScale='off';
                    velocityArrows2.Color=yellow;
                    velocityArrows2.AutoScaleFactor=1;
                    velocityArrows2.LineWidth=arrowCoeff;
                    velocityArrows2.MaxHeadSize=1;
                end
                
                if length(arrows3{1})~=0
                    velocityArrows3=quiver(arrows3{1},arrows3{2},arrows3{3}*arrowSize,arrows3{4}*arrowSize);
                    velocityArrows3.AutoScale='off';
                    velocityArrows3.Color=orange;
                    velocityArrows3.AutoScaleFactor=1;
                    velocityArrows3.LineWidth=arrowCoeff;
                    velocityArrows3.MaxHeadSize=1;
                end
                
                if length(arrows4{1})~=0
                    velocityArrows4=quiver(arrows4{1},arrows4{2},arrows4{3}*arrowSize,arrows4{4}*arrowSize);
                    velocityArrows4.AutoScale='off';
                    velocityArrows4.Color=red;
                    velocityArrows4.AutoScaleFactor=1;
                    velocityArrows4.LineWidth=arrowCoeff;
                    velocityArrows4.MaxHeadSize=1;
                end
                
                
            end
        end
        
        
    end
    if display==2
        displayText=sprintf('Frame: %d\nTime: %0.01f\nSpeed: %0.001f mm/s ', infos(1,1),infos(1,6),infos(1,5));
        text(20,110,displayText,'FontSize',26,'Color',textColor);
    end
    
    
    if display==1 || display==3
        for i=1:length(contour)
            cont=contour{i};
            plot(cont(:,2), cont(:,1),'red','LineWidth',2);
            
        end
        displayText=sprintf('Frame: %d\nTime: %0.01f\nAltitude: %0.1f mm\nDiameter: %0.1f mm\nHeight: %0.1f mm\nSpeed: %0.001f mm/s ', infos(1,1),infos(1,6),infos(1,2),infos(1,3),infos(1,4),infos(1,5));
        text(20,200,displayText,'FontSize',26,'Color',textColor);
    end
    %     displayText=['Frame: ' num2str(infos(1,1)), ', Altitude: ' num2str(infos(1,2)) ' mm', ', Diameter: ' num2str(infos(1,3)) ' mm', ', Speed: ' num2str(infos(1,4)) ' mm/s']
    
    if makeVideo==1
        frame=getframe(fig);
        writeVideo(video,frame);
    end
end
end

