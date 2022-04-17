% Habitat Classication Project

% CLEAR AND LOAD NEW IMAGE
clc, clearvars, close all
ex1_raw = imread("example_1.tiff");
imshow(ex1_raw)

%% Balance the lighting with imtophat()
%maybe consider doing some HSV instead of HSL to avoid lighting issues
%right now we are losing some of the sand patches because they are darker than some patches of eelgrass
el = 4;
seo = strel('disk',el);
ex1_2 = imtophat(ex1_raw,seo);

ex1_2 = imbinarize(ex1_raw);

figure
subplot(1,2,1)
imshow(ex1_raw)
subplot(1,2,2)
imshow(ex1_2)

%%
% Thresholding and Opening
ex1_2 = imbinarize(ex1_raw, 0.23); %binarizes an image using a global image threshold

figure
subplot(1,2,1)
imshow(ex1_raw)
subplot(1,2,2)
imshow(ex1_2)

%% CLOSE out loose boys
close all
el = 6;
seo = strel('disk',el);
ex1_3 = imclose(ex1_2, seo);
imshow(ex1_3)

%% OPEN to make a nice grouping

el = 10;
seo = strel('disk',el);
ex1_4 = imopen(ex1_3, seo);
figure
subplot(1,2,1)
imshow(ex1_raw)
subplot(1,2,2)
imshow(ex1_4)

% percent white
total_pix = size(ex1_3,1)*size(ex1_3,2);
p_white = sum(sum(ex1_3))/total_pix*100
