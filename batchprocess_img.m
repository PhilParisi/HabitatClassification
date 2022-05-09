% FINAL CODE FOR BATCH PROCESSING IMAGES
% B.Motsenbocker, P.Parisi, A.Runyan
% April2022

%%% HOW TO USE THIS SCRIPT (MUST READ)

% Files Needed in Same Folder as Photos
% -batchprocess_img.m (this/main script)
% -homomorph.m
% -all photos to analyze (code set to handle .tiff)

% Output will be
% - habitat statistics (outputted to command window and to .txt file)
% - edited files, ending in _e.tiff
%       - recommended to delete 'edited' files before next run (code to do so before)

%%%% BEGIN SCRIPT
clc, close all, clear all, format compact, tic

%%%% Parameters to Tune 
sigma = 1.0; % for homomorphic filter

%%%% Delete Old Edited Images
%delete *_e*
%disp('...deleting images ending in _e.tiff...')
%pause(2)

%%%% Gather Image FileNames
% Note: you must be in the folder with the images
imgNames = dir('*tiff');        % set to grab all .tiff images
imgNames = { imgNames.name };
imgNames = string(imgNames);

%%%% Counters for Total Habitat Statistics
sand_total = 0;     % pure sand
mix_total = 0;      % mixed sand/segrass/other
grass_total = 0;    % pure seagrass
total_pix = 0;      % total pixels

%%%% Loop over every Image and Perform Series of Filters
disp('...beginning photo analysis...')
for i = 8:8 %length(imgNames)

    %%% Load Current Image
    currentName = imgNames(i);
    img = imread(currentName);
    imgraw = img;

    %%% Convert to Grayscale
    img = rgb2gray(img);
    %figure, imshow(img)

    %%% Apply Homomorphic Filter
    img = homomorph(img, sigma, 0);  
    %figure, imshow(img)

    %%% Apply Multi-Threshold (2 thresholds, 3 bins)
    thresh = multithresh(img, 2);
    seg_img = imquantize(img, thresh);
    RGB = label2rgb(seg_img);
    %figure, imshow(RGB)
    img = rgb2gray(RGB);
    %figure, imshow(img)

    %%% Morphological Operations (closes and opens)
    % close
    SE = strel('rectangle',[15,9]);
    img = imclose(img,SE);
    %figure, imshow(img)
    % open #1
    se = strel('rectangle', [18,15]);
    img = imopen(img, se);
    %figure, imshow(img)
    % open #2
    se2 = strel('rectangle', [25,18]);
    img = imopen(img, se2);
    %figure, imshow(img)
    % open #3
    se3 = strel('disk', 25);
    img = imopen(img, se3);
    %figure, imshow(img)

    %%% Count Pixels for Habitat Statistics    
    total_pix = total_pix + (size(img,1) * size(img,2));
    
    % extract pixel values
    img_vals = unique(unique(img));
    img_vals = sort(img_vals);
    % count sand pixels
    sand_val = img_vals(3);     %highest val is sand
    sand_total = sand_total + sum(sum(img == sand_val));
    % count mix pixels
    mix_val = img_vals(2);      %middle val is mixed
    mix_total = mix_total + sum(sum(img == mix_val));
    % count grass pixels
    grass_val = img_vals(1);    %lowest val is grass
    grass_total = grass_total + sum(sum(img == grass_val));

    % Save Modified Image with _e.tiff ending
    rawName = char(currentName);
    rawName = rawName(1:(length(rawName)-5));
    saveasName = strcat(pwd,'/',rawName,'_e.tiff');    
    imwrite(img,saveasName);

    %figure
    %imshowpair(imgraw,img,'montage')
    disp(strcat("...processed ",num2str(i),"..."))
end
disp('...the results are in!...')

% Calculate Total Habitat Statistics
percent_sand = sand_total / total_pix * 100;
percent_mix = mix_total / total_pix * 100;
percent_grass = grass_total / total_pix * 100;

results = table(percent_sand,percent_mix,percent_grass);
disp(results)

% Write Final Values to Txt File
M = [sigma, i, percent_sand, percent_mix, percent_grass];
dataFile = strcat(string(datetime),".txt");
writematrix(M,dataFile);
disp(strcat("...results saved to ",dataFile,"..."))

toc

