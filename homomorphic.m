% Homomorphic filtering of images

% CLEAR AND LOAD NEW IMAGE
clc, clearvars, close all
ex1_raw = imread("example_1.tiff");
imshow(ex1_raw)

%% MATLAB Tutorial 
% https://blogs.mathworks.com/steve/2013/06/25/homomorphic-filtering-part-1/
clc,  tic, close all, clearvars -except ex1_raw, format compact
I = ex1_raw; % create local test copy


sig = [1, 2, 3, 4, 5, 10, 20];
%sig = 1;
for i = 1:length(sig)
    img = I;
    
    homomorph(I, sig(i));
    
end

disp("...Finished!...")
toc





function [no_out] = homomorph(I, sigma)
disp("...new loop...")
I = im2double(I);  % conver to floating point data type
I = log(1 + I); % convert to log domain

% Create a filter MxN
M = 2*size(I,1) + 1;
N = 2*size(I,2) + 1;

%sigma = 1; % std dev for gaussian which determines
            % bandwidth of low-frequency band we will filter out
            
[X, Y] = meshgrid(1:N,1:M);
centerX = ceil(N/2);
centerY = ceil(M/2);
gaussianNumerator = (X - centerX).^2 + (Y - centerY).^2;
H = exp(-gaussianNumerator./(2*sigma.^2));
H = 1 - H;

%figure
%imshow(H,'InitialMagnification',25)

H = fftshift(H);
If = fft2(I, M, N);
Iout = real(ifft2(H.*If));
Iout = Iout(1:size(I,1),1:size(I,2));
Ihmf = exp(Iout) - 1;

figure
imshowpair(I, Ihmf, 'montage')
title(strcat("Sigma = ", num2str(sigma)))
pause(1)

no_out = 0;
end

