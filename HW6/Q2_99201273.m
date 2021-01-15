function main
    image = imread("Fig0222(b)(cameraman).tif");
    
    [noisy_image, notch] = part_one(image);
    part_two(noisy_image, notch);
end

function [noisy_image, notch] = part_one(image)
    % Description : Add a periodic noise to the image. 
    % Design a multiple notch filter for it
    % Inputs : 
    %           image : the image which we will add noise to
    % Outputs :
    %           noisy_image : image which the noise has been added to it
    %           notch : The notch filter for this noise
    
    noise1 = create_noise(size(image, 2), size(image, 1), 1, 1.5);
    noise2 = create_noise(size(image, 2), size(image, 1), 2, 1.5);
    noise3 = create_noise(size(image, 2), size(image, 1), -1, 1.5);
    noise4 = create_noise(size(image, 2), size(image, 1),  -2, 1.5);
    noisy_image = (noise1 + noise2 + noise3 + noise4) * 20 + double(image);
    
    % fourie transform
    noisy_image_p = padarray(noisy_image, [size(image, 1) size(image, 2)], 'post');
    image_p = padarray(image, [size(image, 1) size(image, 2)], 'post');
    image_fft = fftshift(fft2(image_p));
    noisy_image_fft = fftshift(fft2(noisy_image_p));
    
    % plot images
    figure
    subplot(221);
    imshow(image);
    title("Main image");
    subplot(222);
    imshow(noisy_image, []);
    title("Noisy image");
    subplot(223);
    imshow(log(1 + abs(image_fft)), []);
    title("Main image spectrum");
    subplot(224);
    imshow(log(1 + abs(noisy_image_fft)), []);
    title("Noisy image spectrum");
    
    notch1 = single_notch_filter(size(image, 2) * 2 , size(image, 1) * 2, 123, -82, 30);
    notch2 = single_notch_filter(size(image, 2) * 2 , size(image, 1) * 2, 123, -82 * 2, 30);
    notch3 = single_notch_filter(size(image, 2) * 2 , size(image, 1) * 2, 123, 82, 30);
    notch4 = single_notch_filter(size(image, 2) * 2 , size(image, 1) * 2, 123, 82 * 2, 30);
    notch = notch1 .* notch2 .* notch3 .* notch4;
end

function part_two(noisy_image, notch)
    % Description : Design a band reject filter, and apply it on noisy image
    % and show the filtered image. 
    % Inputs :
    %           noisy_image : image with additive periodic noise
    %           notch : notch filter to apply on image
    
    % fourie transform
    noisy_image_p = padarray(noisy_image, [size(noisy_image, 1) size(noisy_image, 2)], 'post');
    noisy_image_fft = fftshift(fft2(noisy_image_p));
    
    % apply filter
    G = notch .* noisy_image_fft;
    g = ifft2(fftshift(G));
    g = abs(g(1:size(noisy_image, 1), 1:size(noisy_image, 2)));
    
    % plot images
    figure
    subplot(221);
    imshow(noisy_image, []);
    title("Noisy image");
    subplot(222);
    imshow(log(1 + abs(noisy_image_fft)), []);
    title("Noisy image spectrum");
    subplot(223);
    imshow(log(1 + abs(G)), []);
    title("Filtered fourie spectrum");
    subplot(224);
    imshow(g, []);
    title("Denoised image");
end

function output = create_noise(width, height, coeff_i, coeff_j)
    % Description : Create a periodic noise
    % Inputs : 
    %           Width : width of final noise
    %           height : height of final nosie
    %           coeff_i, coeff_j : peak position in fourie spectrum
    % Outputs :
    %           output : periodic noise
    
    output = zeros(height, width, 'double');
    for i=1:height
        for j=1:width
            output(i, j) = sin(coeff_i * i + coeff_j * j);
        end
    end
end

function output = single_notch_filter(width, height, v0, u0, d0)
    % Description : Create a guassian notch bad reject filter
    %   Inputs:
    %           width : width of final filter
    %           Height : height of final filter
    %           v0 : position of reject's center from center of filter (x axis)
    %           u0 : position of reject's center from center of filter (y axis)
    %           d0 : guassian variance
    %   Outputs:
    %           output : final notch filter
    
    H_k = ones(height, width, 'double');
    H_k_p = ones(height, width, 'double');
    for i=1:height
        for j=1:width
            d = (i - ceil(height / 2) - u0) .^ 2 + (j - ceil(width/2) - v0) ^ 2;
            d_p = (i - ceil(height / 2) + u0) .^ 2 + (j - ceil(width/2) + v0) ^ 2;
            H_k(i,j) = 1 - exp(-(d/(2*(d0 ^ 2))));
            H_k_p(i,j) = 1 - exp(-(d_p/(2*(d0 ^ 2))));
        end
    end
    output = H_k .* H_k_p;
end