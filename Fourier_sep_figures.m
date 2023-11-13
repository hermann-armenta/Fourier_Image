% Read the image
originalImage = imread('your_image.jpg'); % Replace 'your_image.jpg' with your image file

% Convert the image to grayscale if it's a color image
if size(originalImage, 3) == 3
    originalImage = rgb2gray(originalImage);
end

% Compute the Fourier Transform
fourierTransform = fft2(originalImage);
shiftedFourier = fftshift(fourierTransform); % Shift zero frequency components to the center

% Display the original image in the first figure
figure;
imshow(originalImage);
title('Original Image');
colormap gray;
axis off;
axis equal;

% Display the Fourier Transform in the second figure
figure;
imagesc(log(abs(shiftedFourier) + 1)); % Use log scale for better visualization
colormap jet;
title('Fourier Transform');
axis off;
axis equal;

% Set the precision level (percentage of coefficients to keep)
precisionLevel = 0.1; % Adjust this value as needed (e.g., 0.1 for 10% precision)

% Determine the number of coefficients to keep
numRows = size(shiftedFourier, 1);
numCols = size(shiftedFourier, 2);
numCoefficientsToKeep = round(precisionLevel * min(numRows, numCols));

% Create a mask to keep only a portion of the coefficients
mask = zeros(size(shiftedFourier));
startRow = max(1, floor(numRows/2 - numCoefficientsToKeep/2));
endRow = min(numRows, startRow + numCoefficientsToKeep - 1);
startCol = max(1, floor(numCols/2 - numCoefficientsToKeep/2));
endCol = min(numCols, startCol + numCoefficientsToKeep - 1);
mask(startRow:endRow, startCol:endCol) = 1;

% Apply the mask to the shifted Fourier Transform
maskedFourier = shiftedFourier .* mask;

% Reconstruct the image from the masked Fourier Transform
reconstructedImage = ifft2(ifftshift(maskedFourier));

% Display the reconstructed image in the third figure
figure;
imshow(abs(reconstructedImage), []);
title(['Reconstructed Image (', num2str(precisionLevel*100), '% Precision)']);
colormap gray;
axis off;
axis equal;
