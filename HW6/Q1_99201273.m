function main
    image = imread("Fig0450(a)(woman_original).tif");
    
    noisy_image = part_one(image);
    H = part_two(noisy_image);
    part_three(noisy_image, H);
end

function noisy_image = part_one(image)
    % Description : Add a periodic noise to the image. Finally Show the 
    % noisy image next to its spectrum, where we can see the noise patterns
    % Inputs : 
    %           image : the image which we will add noise to
    % Outputs :
    %           noisy_image : image which the noise has been added to it
    
    noise1 = create_noise(size(image, 2), size(image, 1), 0, 2);
    noise2 = create_noise(size(image, 2), size(image, 1), 2, 0);
    noise3 = create_noise(size(image, 2), size(image, 1), 1, sqrt(3));
    noise4 = create_noise(size(image, 2), size(image, 1),  1, -sqrt(3));
    noisy_image = (noise1 + noise2 + noise3 + noise4) * 30 + double(image);
    
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
end

function H = part_two(noisy_image)
    % Description : Design a band reject filter, and apply it on noisy image
    % and show the filtered image. 
    % Inputs :
    %           noisy_image : image with additive periodic noise
    % Outputs :
    %           H : the band reject filter
    
    % fourie transform
    noisy_image_p = padarray(noisy_image, [size(noisy_image, 1) size(noisy_image, 2)], 'post');
    noisy_image_fft = fftshift(fft2(noisy_image_p));
    H = band_reject_filter(size(noisy_image, 1) * 2, size(noisy_image, 2) * 2, 475, 120);
    
    % apply filter
    G = H .* noisy_image_fft;
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
    imshow(H, []);
    title("The band reject filter");
    subplot(224);
    imshow(g, []);
    title("Denoised image");
end

function part_three(noisy_image, H)
    % Description : Extract the noise pattern and show it in a separate window.
    % Inputs : 
    %           H : Band reject filter
    %           noisy_image : image with noise
    
    % create a band pass filter
    BP = 1 - H;
    
    % fourie transform
    noisy_image_p = padarray(noisy_image, [size(noisy_image, 1) size(noisy_image, 2)], 'post');
    noisy_image_fft = fftshift(fft2(noisy_image_p));
    
    % apply filter
    G = BP .* noisy_image_fft;
    g = ifft2(fftshift(G));
    g = abs(g(1:size(noisy_image, 1), 1:size(noisy_image, 2)));
    
    figure;
    imshow(g, []);
    title("Noise pattern");
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

function output = band_reject_filter(height, width, d0, w)
    % Description : guassian band reject filter
    % Inputs :
    %           height : height of final filter
    %           width : width of final filter
    %           d0 : cutoff frequency
    %           w : width of band reject filter
    % Outputs :
    %           Output : the filter
    output = zeros(height, width, 'double');
    for i=1:height
        for j=1:width
            d = sqrt((i - ceil(height / 2)) .^ 2 + (j - ceil(width / 2)) .^ 2);
            output(i, j) = 1 - exp(- ((d .^ 2 - d0 .^ 2) / (d .* w)) .^ 2);
        end
    end
end