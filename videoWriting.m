function [ makeVideo,video ] = videoWriting(video, image, contour, infos,coordArrow,arrowCoeff, makeVideo )
%Create a video out of the images given

if makeVideo~=0;
    fig=figure('visible','off');
    imshow(image)
    hold on
    
    
    if makeVideo==1 || makeVideo==2
        if size(coordArrow)~=0
            arrows=quiver(coordArrow{1},coordArrow{2},coordArrow{3},coordArrow{4});
            arrows.Color='red';
            arrows.AutoScaleFactor=1;
            arrows.LineWidth=arrowCoeff;
            arrows.MaxHeadSize=1;
        end
        displayText=sprintf('Frame: %d\nTime: %0.01f\nSpeed: %0.001f mm/s ', infos(1,1),infos(1,6),infos(1,5));
        text(20,80,displayText,'FontSize',26,'Color',[0 1 0]);
    end
    
    
    if makeVideo==1 || makeVideo==3
        for i=1:length(contour)
            cont=contour{i};
            plot(cont(:,2), cont(:,1),'r','LineWidth',2);
        end
        displayText=sprintf('Frame: %d\mTime: %0.01f\nAltitude: %0.1f mm\nDiameter: %0.1f mm\nHeight: %0.1f mm\nSpeed: %0.001f mm/s ', infos(1,1),infos(1,6),infos(1,2),infos(1,3),infos(1,4),infos(1,5));
        text(20,180,displayText,'FontSize',26,'Color',[0 1 0]);
    end
    %     displayText=['Frame: ' num2str(infos(1,1)), ', Altitude: ' num2str(infos(1,2)) ' mm', ', Diameter: ' num2str(infos(1,3)) ' mm', ', Speed: ' num2str(infos(1,4)) ' mm/s']
    frame=getframe(fig);
    writeVideo(video,frame);
end

end
