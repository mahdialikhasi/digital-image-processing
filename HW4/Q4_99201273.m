function main
    % read image
    image = imread("Fig0441(a)(characters_test_pattern).tif");
    dim = size(image);
    % padding parameters
    % we assumed that the filter is the same size as the picture
    p = 2 * dim(2);
    q = 2 * dim(1);
    % padd image
    paded_image = padarray(image, [(q-dim(1)) (p-dim(2))], 'post');
    % multiply it by (-1) ^ (x + y)
    centered_image = center_fourie(paded_image);
    % compute dft
    fft_image = fft2(centered_image);
    
    % preserving 80 percent
    my_plot(image, fft_image, 80, 2);
    
    % preserving 90 percent
    my_plot(image, fft_image, 90, 2);
    
    % preserving 95 percent
    my_plot(image, fft_image, 95, 2);
end

function output = fft_to_image(image, width, height)
    % Description : reverse transform the fourie domain and remove zero
    % padd and multiply it by (-1) ^ (x + y)
    % Inputs :
    %       image : image in fourie domain
    %       width : width of final image
    %       height : height of final image
    % Outputs :
    %       output : image in spacial domain
    
    % obtain the processed image
    ifft_image = ifft2(image);
    real_ifft_image = real(ifft_image);
    processed_image = center_fourie(real_ifft_image);
    
    output = processed_image(1:height, 1:width);
end

function output = ideal_lowpass_filter(width, height, d0)
    % Description : Return H(u, v) as an ideal low pass filter in the
    % center of a width * height filter
    % Inputs:
    %       width : Width of filter
    %       height : Height of filter
    %       d0 : cut of frequency
    % Outputs :
    %       output : final filter

    output = zeros(height, width, 'double');
    for i=1:height
        for j=1:width
            d = sqrt((i - ceil(height / 2)) ^ 2 + (j - ceil(width / 2)) ^ 2); 
            if(d <= d0)
                output(i,j) = 1;
            end
        end
    end
end

function [d0, output] = ilpf_cutoff_freq(image, alpha)
    % Description : find the cutoff freq of ilpf such that it preserves
    % alpha percent of power spectrum
    % Inputs :
    %       image : zero padded centered image in frequency domain
    %       alpha : the percent of power spectrum which we want to preserve
    % Outputs : 
    %       d0 : cut-off frequencty
    %       output : filtered image
    
    power_total = sum(sum(abs(image) .^ 2));
    for i = 1:max(size(image))
        g = ideal_lowpass_filter(size(image,2), size(image, 1), i);
        y = g .* image;
        p = sum(sum(abs(y) .^ 2));
        if(100 * p >= alpha * power_total)
            output = y;
            d0 = i;
            break;
        end
    end
end

function output = butterworth_lowpass_filter(width, height, d0, n)
    % Description : Return H(u, v) as a butterworth low pass filter in the
    % center of a width * height filter
    % Inputs:
    %       width : Width of filter
    %       height : Height of filter
    %       d0 : cut of frequency
    %       n : order of BLPF
    % Outputs :
    %       output : final filter
    
    output = zeros(height, width, 'double');
    for i=1:height
        for j=1:width
            d = sqrt((i - ceil(height / 2)) ^ 2 + (j - ceil(width / 2)) ^ 2); 
            output(i, j) = 1 / (1 + ((d/d0) ^ (2 * n)));
        end
    end
end

function [d0, output] = blpf_cutoff_freq(image, alpha, n)
    % Description : find the cut-off freq of blpf such that it preserves
    % alpha percent of power spectrum
    % Inputs :
    %       image : zero padded centered image in frequency domain
    %       alpha : the percent of power spectrum which we want to preserve
    %       n : order of filter
    % Outputs : 
    %       d0 : cut-off frequencty
    %       output : filtered image
    
    power_total = sum(sum(abs(image) .^ 2));
    for i = 1:max(size(image))
        g = butterworth_lowpass_filter(size(image,2), size(image, 1), i, n);
        y = g .* image;
        p = sum(sum(abs(y) .^ 2));
        if(100 * p >= alpha * power_total)
            d0 = i;
            output = y;
            break;
        end
    end
end

function output = gaussian_lowpass_filter(width, height, d0)
    % Description : Return H(u, v) as a gaussian low pass filter in the
    % center of a width * height filter
    % Inputs:
    %       width : Width of filter
    %       height : Height of filter
    %       d0 : cut of frequency
    % Outputs :
    %       output : final filter
    
    output = zeros(height, width, 'double');
    for i=1:height
        for j=1:width
            d = sqrt((i - ceil(height / 2)) ^ 2 + (j - ceil(width / 2)) ^ 2); 
            output(i, j) = exp((-1 * (d ^ 2))/(2 * (d0 ^ 2)));
        end
    end
end

function [d0, output] = glpf_cutoff_freq(image, alpha)
    % Description : find the cutoff freq of glpf such that it preserves
    % alpha percent of power spectrum
    % Inputs :
    %       image : zero padded centered image in frequency domain
    %       alpha : the percent of power spectrum which we want to preserve
    % Outputs : 
    %       d0 : cut-off frequencty
    %       output : filtered image
    
    power_total = sum(sum(abs(image) .^ 2));
    for i = 1:max(size(image))
        g = gaussian_lowpass_filter(size(image,2), size(image, 1), i);
        y = g .* image;
        p = sum(sum(abs(y) .^ 2));
        if(100 * p >= alpha * power_total)
            d0 = i;
            output = y;
            break;
        end
    end
end

function output = center_fourie(image)
    % Description : multiply each pixel by (-1) ^ (x + y)
    % Inputs :
    %       image : main image
    % Outputs :
    %       output : output image after multiplying
    dim = size(image);
    output = double(image);
    for i=1:dim(1)
        for j=1:dim(2)
            if(mod(i - 1 + j - 1, 2) ~= 0)
                output(i, j) = -1 * output(i, j);
            end
        end
    end
end

function my_plot(image, fft_image, percent, n)
    % Description : Plot main image, ilpf image, blpf ,and glpf with
    % respect to the percent of power spectrum
    % Inputs :
    %       fft_image : image in fourie domain
    %       percent : the percent of power spectrum which we want to
    %       preserve
    %       n : order of blpf
    dim = size(image);
    
    figure;
    subplot(141);
    imshow(image);
    title("Main image");
    
    subplot(242);
    [d0, ilpf] = ilpf_cutoff_freq(fft_image, percent);
    ilpf_final = fft_to_image(ilpf, dim(2), dim(1));
    imshow(uint8(ilpf_final));
    title("ILPF - " + num2str(percent) +"% - d0=" + num2str(d0));
    subplot(246);
    imshow(uint8(double(image) - ilpf_final));
    title("diff (ILPF)");
    
    subplot(243);
    [d0, glpf] = glpf_cutoff_freq(fft_image, percent);
    glpf_final = fft_to_image(glpf, dim(2), dim(1));
    imshow(uint8(glpf_final));
    title("GLPF - " + num2str(percent) +"% - d0=" + num2str(d0));
    subplot(247);
    imshow(uint8(double(image) - glpf_final));
    title("diff (GLPF)");
    
    subplot(244);
    [d0, blpf] = blpf_cutoff_freq(fft_image, percent, n);
    blpf_final = fft_to_image(blpf, dim(2), dim(1));
    imshow(uint8(blpf_final));
    title("BLPF - " + num2str(percent) +"% - n=" + num2str(n) + " - d0=" + num2str(d0));
    subplot(248);
    imshow(uint8(double(image) - blpf_final));
    title("diff (BLPF)");
end