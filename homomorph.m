function [Ihmf] = homomorph(I, sigma, graph)
% Takes in image, I
% Applies filter with coeff sigma
% Graph is third argument, 1 for yes, 0 for no
% Returns new image
% https://blogs.mathworks.com/steve/2013/06/25/homomorphic-filtering-part-1/


disp("...running homomorphic filter...")
I = im2double(I);  % conver to floating point data type
I = log(1 + I); % convert to log domain

% Create a filter MxN
M = 2*size(I,1) + 1;
N = 2*size(I,2) + 1;

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

% Plots
if graph == 1
    figure
    imshowpair(I, Ihmf, 'montage')
    title(strcat("Side-by-Side, Sigma = ", num2str(sigma)))
    pause(0.5)

    figure
    imshow(Ihmf,[min(Ihmf(:)),max(Ihmf(:))]); %default is [0,1]
    title(strcat("Sigma = ", num2str(sigma)))
    pause(1)
end


end

