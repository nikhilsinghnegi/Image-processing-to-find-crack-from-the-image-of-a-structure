I = imread('crack-101.jpg');%reading the image


%% brightness increase 1

Bblend = imlocalbrighten(I,'AlphaBlend',true);
montage({I,Bblend})
title({'original image & brightness increase'})

%% sharpen the image 2

B = imsharpen(Bblend,'Radius',2.5,'Amount',1.5);
figure()
imshow(B)
title('after sharpening')

%% changing the contrast(only applicable for gray scale image) 3

B_gray = rgb2gray(B);
B_contra = imadjust(B_gray,stretchlim(B_gray),[]);
figure()
imshow(B_contra)
title('contrast increase')

%% subplotting
subplot(1,2,1)
imshow(I)
title('original image')

subplot(1,2,2)
imshow(B_contra)
title('increased contrast')

%% to apply edge detection algorithm 'canny'
I2 = im2gray(I);
BW1 = edge(I2,'canny');
figure
imshow(BW1)
title('edge detec in normal image')


%% for that contrasting image finding the edge using 'canny' algo
A02 = edge(B_contra,'canny');%edge finding
figure
imshow(A02)
title('edge detec in contra image "canny"')

figure
imshowpair(BW1,A02,'montage')%comparing normal image vs contrasting image edge detection
title('comparing normal image vs contrasting image edge detection')

%% for that contrasting image finding the edge using other algos(changing threshold and directions)
A03 = edge(B_contra,'canny',0.5);%edge finding
figure
imshow(A03)
title('edge detec in contra image "canny" after changing threshold')

%% region properties and crack highlighting

BW_out = bwpropfilt(A03, 'Area', [150 + eps(200), Inf]);
BW_out = bwpropfilt(BW_out, 'Perimeter', [100 + eps(100), Inf]);

figure
imshow(BW_out)
title('Crack extracted')

arr = size(A03);
i2 = I;

for l =1:arr(1)
    
    for b =1:arr(2)
        
        if BW_out(l,b)==1
            
            for h = 1:20
                
                if (l+10-h > 0) && (b+10-h > 0) && (l+10-h < arr(1)) && (b+10-h < arr(2))
                    i2(l+10-h, b+10-h, 2) = 255;
                end
                
            end
        end
    end
end

figure
imshow(i2)
title('Highlighted image of crack')

figure
subplot(2,2,1)
imshow(I)
subplot(2,2,2)
imshow(A03)
subplot(2,2,3)
imshow(BW_out)
subplot(2,2,4)
imshow(i2)


%% segmentation
G = i2(:,:,2);
%imtool(R) %to do segmentation based on red pixel values (and find the limits for thresholding also in there)
G_bw = (G==255);
figure 
imshow(G_bw)


%% region properties and crack highlighting

G_BW_out = bwpropfilt(G_bw, 'Area', [100 + eps(200), Inf]);
G_BW_out = bwpropfilt(G_BW_out, 'Perimeter', [100 + eps(100), Inf]);

properties = regionprops(G_BW_out, {'Area', 'Eccentricity', 'EquivDiameter', 'EulerNumber', 'MajorAxisLength', 'MinorAxisLength', 'Orientation', 'Perimeter'});
figure()
imshow(G_BW_out)
title('Crack extracted black & white')

%% interactive dimension check
figure()
imshow(I)
d = imdistline;

%% 
sizy = size(I,1);
sizx = size(I,2); % or any other way to find the number of pixels in the horizontal  
                  % direction if you are not using imread.
xmax = sizx*.100; %multiplying with the factor that how much value one pixel will be having in the x
%similarly doing it for y
ymax = sizy*.100;
figure()
image([0 xmax],[0 ymax],I)