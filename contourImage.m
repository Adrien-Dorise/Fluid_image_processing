
function[contourImage]=contour(b)

% Filter an image to have only the countour and change the format to binary
% Utilisation de l'algorithme de Prewitt
% Argument:image
% Return:image

%     b=rgb2gray(image);
%     b=double(b)/255.0;
%     b=im2bw(b);
    threshold=0.26; %Modifying the threshold to improve the quality of the contour
    H=fspecial('prewitt');
%     H=fspecial('sobel');
    V=-H';
    Gh=filter2(H,b);
    Gv=filter2(V,b);
    G=sqrt(Gh.*Gh + Gv.*Gv);
    Gs=(G>threshold);
    contourImage=Gs;
    
end
