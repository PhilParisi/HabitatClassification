% Homomorphic filtering of images
% Roman Project 2022
% Phil Parisi

%% CLEAR AND LOAD NEW IMAGE
clc, clearvars, close all
ex1_raw = imread("example_1.tiff");

figure, imshow(ex1_raw)

I = ex1_raw;

I = im2double(I); % unit8 --> double values in range [0,1]
figure, imshow(I)

%% Homomorphic Filtering
clc,  tic, close all, clearvars -except ex1_raw, format compact

I = ex1_raw;            % create local test copy
image_array = {};       % define image array to hold homomorphic images

% Loop over different sigma filter values and save homomorphed images
sig = [0.5, 1, 2, 3, 4, 5, 10, 20, 35, 50];
for i = 1:length(sig)    
    image_array{i} = homomorph(I, sig(i),0);  
end


disp("...Finished!...")
toc

%% Thresholding Raw vs. Post-Morph
clc, close all, format compact, clearvars -except ex1_raw

% Threshold Raw Image
ex1_thresh = 0.20;
ex1_thresh = imbinarize(ex1_raw, ex1_thresh);

% Homomorphic Filter & Side-by-Side Comparisons
I = ex1_raw;            % create local test copy
image_array = {};       % define image array to hold homomorphic images

% Loop over different sigma filter values and save homomorphed images
sig = [0.5, 1, 1.5, 2, 2.5, 3, 4, 5, 10, 20, 35, 50];

for i = 1:length(sig)    

    % Homomorphic filtering
    image_array{i} = homomorph(I, sig(i),0);

    % Thresholding
    img = image_array{i};
    thresh_val = graythresh(img);
    img_thresh = imbinarize(img,thresh_val);

    figure
    subplot(2,1,1)
    imshowpair(ex1_thresh, img_thresh, 'montage')
    title('Raw Image w/ Thresh (left) vs. Homomorphed w/ Thresh (right)')
    subplot(2,1,2)
    imshowpair(ex1_raw, img, 'montage')
    title(strcat("Raw Image (left) vs. Homomorphed w/ ",num2str(sig(i))," (right)"))
    pause(1)

end


disp("...Finished!...")
toc