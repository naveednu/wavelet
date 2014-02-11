function [tiled_image, recon_image] = wavelet(I, weight, level)
% Perform discrete wavelet transform
%   I = the input image
%   weight = weight to assign to each coefficient
%   level = levels of decomposition 
%
% tiled_image = Output image (4 subimages) showing detail coefficients
% recon_image = Output image (4 subimages) after reverse wavelet
%               transform and applying cofficient weights
% 
if ndims(I) > 2
    image = rgb2gray(I); % convert to gray scale if its RGB
else
    image = I;
end
num_levels = level;         % number of decompositions
num_colors = 256;           % number of values per color component

cA = cell(1,num_levels);    % approximation coefficients
cH = cell(1,num_levels);    % horizontal detail coefficients
cV = cell(1,num_levels);    % vertical detail coefficients
cD = cell(1,num_levels);    % diagonal detail coefficients
start_image = image;

% Calculate discrete wavelet transform using Daubechies filter
for i = 1:num_levels,
    [cA{i}, cH{i}, cV{i}, cD{i}] = dwt2(start_image, 'db1');
    start_image = cA{i};
end

% Create tiled image with horizontal, vertical and diagonal components
tiled_image = wcodemat(cA{num_levels}, num_colors);

for i = num_levels:-1:1,
    new_cH = wcodemat(cH{i}, num_colors);
    new_cV = wcodemat(cV{i}, num_colors);
    new_cD = wcodemat(cD{i}, num_colors);
    tiled_image = [tiled_image-1 new_cH; new_cV new_cD];
end

tiled_image = uint8(tiled_image-1); % convert to unsigned 8-bit

% Reconstruct image by calculating reverse transform, apply weight to each
% coefficient
full_image = cA{num_levels};
for i = num_levels:-1:1,
    full_image = idwt2(full_image, cH{i}*weight, cV{i}*weight, cD{i}*weight,'db1');
end

% construct partial image by omitting detail coefficients
partial_image = cA{num_levels};
for i = num_levels:-1:1,
    partial_image = idwt2(partial_image,[],[],[],'db1');
end

recon_image = [image full_image; partial_image zeros(size(image))];
recon_image = uint8(recon_image);
end




