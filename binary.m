
function[image]=contour(image,treshold,blackWhite)

% Transform a RGB picture in a binary file using the value of the treshold
% + remove the black dots
% Argument:image, treshold (int value between 1 and 255)
% Return:image

if blackWhite ~= 1
    image=rgb2gray(image);
end
image(image<treshold)=0;
image(image>200)=0;
image(image>=treshold)=255;
image=logical(image);
    
end