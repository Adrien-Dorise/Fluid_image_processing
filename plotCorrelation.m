function [  ] = plotCorrelation( allCorrelation, pauseTime, coordX, coordY )
%This funciton plot in 3D the correlation values from the squarre described by the X and Y coordinates
%If no movement detected (no correlation), nothing is displayed

[sizeX,sizeY] = size(allCorrelation);
if (sizeX >= coordX) && (sizeY >= coordY)
    if (find(allCorrelation{coordX,coordY}))
        close all
        [X,Y]=meshgrid(1:1:length(allCorrelation{coordX,coordY}));
        surf(X,Y,allCorrelation{coordX,coordY});
        pause(pauseTime)
    end
else
    "WARNING FUNCTION PLOTCORRELATION: the cell allCorrelation is too small for the desired coordinates"
end
    
end

