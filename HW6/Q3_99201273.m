function main
    image = imread("Fig0503 (original_pattern).tif");
    
    % apply noises
    gaussian_noise = uint8(imnoise(image, 'gaussian'));
    rayleigh_noise = uint8(double(image) + raylrnd(15, size(image, 1), size(image, 2)));
    k = -1/2;
    R = zeros(size(image, 1), size(image, 2));
    for j = 1:20
        R = R + k * log(1 - rand(size(image, 1), size(image, 2)));
    end
    gamma_noise = uint8(double(image) + R);
    exponential_noise = uint8(double(image) + (-10*log(1-rand(size(image, 1), size(image, 2)))));
    uniform_noise = uint8(double(image) + (-10+(50+10)*rand(size(image, 1), size(image, 2))));
    salt_pepper_noise = uint8(imnoise(image,'salt & pepper', 0.2));
    
    % plot noises
    figure;
    subplot(231);
    imshow(gaussian_noise);
    title("gaussian noise");
    subplot(232);
    imshow(rayleigh_noise);
    title("rayleigh noise");
    subplot(233);
    imshow(gamma_noise);
    title("gamma noise");
    subplot(234);
    imhist(gaussian_noise);
    title("gaussian noise histogram");
    subplot(235);
    imhist(rayleigh_noise);
    title("rayleigh noise histogram");
    subplot(236);
    imhist(gamma_noise);
    title("gamma noise histogram");
    
    figure;
    subplot(231);
    imshow(exponential_noise);
    title("exponential noise");
    subplot(232);
    imshow(uniform_noise);
    title("uniform noise");
    subplot(233);
    imshow(salt_pepper_noise);
    title("salt_pepper noise");
    subplot(234);
    imhist(exponential_noise);
    title("exponential noise histogram");
    subplot(235);
    imhist(uniform_noise);
    title("uniform noise histogram");
    subplot(236);
    imhist(salt_pepper_noise);
    title("salt_pepper noise histogram");
    
    % noise removal
    noise_remove(gaussian_noise, 'mean', 'gaussian');
    noise_remove(rayleigh_noise, 'mean', 'rayleigh');
    noise_remove(gamma_noise, 'mean', 'gamma');
    noise_remove(exponential_noise, 'mean', 'exp');
    noise_remove(uniform_noise, 'mean', 'uniform');
    noise_remove(salt_pepper_noise, 'median', 'salt pepper');
end

function noise_remove(noisy_image, method, type)
    % Description : Remove noise from a noisy image
    % Inputs:
    %           noisy_image : noisy image
    %           type : type of noise
    %           method : the method for denoising
    figure;
    subplot(221);
    imshow(noisy_image);
    title("Noisy image : " + type);
    subplot(222);
    imhist(noisy_image);
    title("Noisy histogram");
    subplot(223);
    switch method
        case 'mean'
            denoise = uint8(filter2(1/9 * ones(3,3, 'double'),(filter2(1/9 * ones(3,3, 'double'),noisy_image))));
        case 'median'
            denoise = uint8(medfilt2(noisy_image, [5 5]));
        case 'geomean'
            denoise = uint8(geomean(noisy_image));
    end
    imshow(denoise);
    title("denoised image");
    subplot(224);
    imhist(denoise);
    title('denoised histogram')
end