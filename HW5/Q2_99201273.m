function main
    image = imread("Fig0222(b)(cameraman).tif");
    
    noise = create_noise(size(image, 2), size(image, 1), 70 * pi);
    noisy_image = noise * 40 + double(image);
    
    % fourie transform
    m = size(image, 1) * 2;
    p = size(image, 2) * 2;
    image_p = zeros(m,p,'double');
    image_p(1:size(image, 1), 1:size(image, 2)) = image;
    noisy_image_p = zeros(m, p, 'double');
    noisy_image_p(1:size(image, 1), 1:size(image, 2)) = noisy_image;
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
    
    % create notch filter
    notch = single_notch_filter(p, m, 142, -138, 30);
    image_filtered = notch .* noisy_image_fft;
    noise_removed_img = real(ifft2(fftshift(image_filtered)));
    noise_removed_img = noise_removed_img(1:size(image, 1), 1:size(image, 2));
    
    % plot
    figure;
    subplot(221);
    imshow(notch, []);
    title("Notch filter");
    subplot(222);
    imshow(log(1 + abs(image_filtered)), []);
    title("Filtering the noisy image spectrum");
    subplot(224);
    imshow(noise_removed_img, []);
    title("Noise removed image");
    subplot(223);
    imshow(noisy_image, []);
    title("Noisy image");
end

function output = create_noise(width, height, lambda)
    % Description : Create a periodic 2D Sine noise with the range from
    % zero to Sin(lambda)
    % Inputs : 
    %           Width : width of final noise
    %           height : height of final nosie
    %           Lambda : maximum value of theta of sine
    % Outputs :
    %           output : periodic noise
    
    output = zeros(height, width, 'double');
    % Sine noise
    a = (0:(1/width):1) .* lambda;
    for i=1:size(output,1)
        tmp = sin(a) .* cos(a);
        output(i,:) = tmp(1:width);
        a = circshift(a,1);
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