function main
    image = imread("Fig0427(a)(woman).tif");
    dim = size(image);
    
    % Step one
    % padding parameters
    % we assumed that the filter is the same size as the picture
    p = 2 * dim(2);
    q = 2 * dim(1);
    
    % Step two
    % padd image
    paded_image = padarray(image, [(q-dim(1)) (p-dim(2))], 'post');
    
    % Step three
    % multiply it by (-1) ^ (x + y)
    centered_image = center_fourie(paded_image);
    
    % Step four
    % compute dft
    fft_image = fft2(centered_image);
    
    % Step five
    % Create H(u, v) = ideal lowpass filter
    H = zeros(q,p,'double');
    H(int16(q/2) - 80:int16(q/2) + 80, int16(p/2) - 80:int16(p/2) + 80) = 1;
    G = H .* fft_image;
    
    % Step six
    % obtain the processed image
    ifft_image = ifft2(G);
    real_ifft_image = real(ifft_image);
    processed_image = center_fourie(real_ifft_image);
    
    % Step seven
    final_image = processed_image(1:dim(1), 1:dim(2));
    
    % Plot
    figure;
    subplot(331);
    imshow(image);
    title("Main image");
    
    subplot(332);
    imshow(paded_image);
    title("zero padded image")
    
    subplot(333);
    imshow(centered_image, []);
    title("multiply image by (-1) ^ (x + y)");
    
    subplot(334);
    imshow(2 * log(1 + abs(fft_image)), []);
    title("Spectrum of Fp");
    
    subplot(335);
    imshow(H, []);
    title("Lowpass Filter");
    
    subplot(336);
    imshow(2 * log(1 + abs(G)), []);
    title("Spectrum of HFp");
    
    subplot(337);
    imshow(processed_image, []);
    title("inverse fourie image");
    
    subplot(338);
    imshow(final_image, []);
    title("final image");
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