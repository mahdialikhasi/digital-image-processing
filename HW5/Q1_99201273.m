function main
    % Read image
    image = imread("Fig0462(a)(PET_image).tif");
    
    % apply homomorphic
    Lh = 2;
    Ll = 0.25;
    c = 1;
    d0 = 80;
    homomorphic = homomorphic_filter(Ll, Lh, c, d0, image);
    
    figure;
    subplot(121);
    imshow(image);
    title("Main image");
    subplot(122);
    imshow(homomorphic, []);
    title("Filtered image : Lambda_H = " + num2str(Lh) + ", Lambda_L = " + num2str(Ll));
end

function output = homomorphic_filter(Ll, Lh, c, d0, image)
    % Description : Perform homomorphic filter on image
    % Inputs:
    %           Lh : lambda high. Max value of filter
    %           Ll : Lambda low. Min value of filter
    %           image : The main image which we will aplly filter on
    %           c : Guassian power co efficient
    %           d0 : Guassian variance
    % Outputs:
    %           Output : Filtered image
    
    % apply ln on image so that z = ln(illumination) + ln(reflection)
    z = log(1 + double(image));
    
    % zero pad image to prevent wraparound error
    dim = size(image);
    z_p = zeros(dim(1) * 2, dim(2) * 2, 'double');
    z_p(1:dim(1),1:dim(2)) = z;
    
    % center the image
    z_c = center_fourie(z_p);
    
    % create filter H
    H = zeros(dim(1) * 2, dim(2) * 2, 'double');
    for i=1:size(H, 1)
        for j=1:size(H, 2)
            d = (i - ceil(size(H, 1) / 2)) ^ 2 + (j - ceil(size(H, 2) / 2)) ^ 2;
            H(i, j) = (Lh - Ll) .* (1 - exp(-c * (d/(d0 .^ 2)))) + Ll;
        end
    end
    
    % Apply filter
    Z = fft2(z_c);
    G = Z .* H;
    
    % inverse transform
    g = real(ifft2(G));
    
    g_p = center_fourie(g);
    g_i = g_p(1:dim(1), 1:dim(2));
    
    % inverse ln
    output = exp(g_i) - 1;
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