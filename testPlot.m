function [  ] = testPlot( testPos,testDiam,testSpeed )
%Plot the different test inputs
%   Detailed explanation goes here

figure(1);plot(testPos(2:end)); title('Position');
figure(2);plot(testDiam(2:end)); title('Diameter');
figure(3);plot(testSpeed(2:end)); title('Speed');

end

