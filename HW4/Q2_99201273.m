function main
    % read image
    image = imread("Fig0427(a)(woman).tif");
    dim = size(image);
    
    % part a
    % create a rectangle
    rectangle_image = rectangle(dim(2), dim(1), int16(dim(2) / 16), int16(dim(2) / 4));
    
    % fft of rectangle
    fft_rectangle = fft2(rectangle_image);
    
    % center fourie transform by multiplying image by (-1) ^ (x + y)
    centered_rectangle = center_fourie(rectangle_image);
    fft_centered_rectangle = fft2(centered_rectangle);
    
    % Plot the rectangle
    figure;
    subplot(221);
    imshow(rectangle_image);
    title("Rectangle");
    subplot(222);
    % calc spectrum and scale to [0 255]
    imshow(abs(fft_rectangle), []);
    title("Spectrum of rectangle");
    subplot(223);
    imshow(abs(fft_centered_rectangle), []);
    title("Spectrum of rectangle after being centered in fouried space");
    subplot(224);
    imshow(abs(2 * log(1 + fft_centered_rectangle)), []); % log transformation
    title("Spectrum of rectangle after applying log transform");
    
    % Part b
    % translate rectangle
    % get the rotation angel and translations from user
    dx = input("please enter translattion in x axis : ");
    dy = input("please enter translation in y axis : ");
    angel = input("please enter rotation angel in degree : ");
    translated_rectangle = warp_image(rectangle_image, [1,0,dx;
                                                        0,1,dy;
                                                        0,0,1]);
    
    % center fourie transform by multiplying image by (-1) ^ (x + y)
    centered_translated_rectangle = center_fourie(translated_rectangle );
    fft_centered_translated_rectangle = fft2(centered_translated_rectangle);
    
    rotated_rectangle = warp_image(rectangle_image, [cosd(angel),-sind(angel),0;
                                                        sind(angel),cosd(angel),0;
                                                        0,0,1]);
    % center fourie transform by multiplying image by (-1) ^ (x + y)
    centered_rotated_rectangle = center_fourie(rotated_rectangle );
    fft_centered_rotated_rectangle = fft2(centered_rotated_rectangle);
    
    % plot
    figure;
    subplot(221);
    imshow(translated_rectangle);
    title("Translated rectangle");
    subplot(222);
    imshow(abs(2 * log(1 + fft_centered_translated_rectangle)), []); % log transformation
    title("Fourie spectrum of translated rectangle");
    subplot(223);
    imshow(rotated_rectangle);
    title("Rotated rectangle");
    subplot(224);
    imshow(abs(2 * log(1 + fft_centered_rotated_rectangle)), []); % log transformation
    title("Fourie spectrum of rotated rectangle");
    
    % part c
    figure;
    subplot(131);
    imshow(angle(fft_centered_rectangle), []);
    title("Phase of centered rectangle");
    subplot(132);
    imshow(angle(fft_centered_translated_rectangle), []);
    title("Phase of translated rectangle");
    subplot(133);
    imshow(angle(fft_centered_rotated_rectangle), []);
    title("Phase of rotated rectangle");

    % Part d
    figure;
    subplot(231);
    imshow(image);
    title("Main image");
    subplot(232);
    fft_image = fft2(image);
    imshow(angle(fft_image), []);
    title("Phase of image");
    subplot(233);
    reconstructed_image_by_phase = ifft2(fft_image ./ abs(fft_image)); % reverse transform the image with |F(u,v)| = 1
    imshow(reconstructed_image_by_phase, []);
    title("Reconstruction using only the phase");
    subplot(234);
    reconstructed_image_by_spectrum = ifft2(abs(fft_image) + 0i); % reverse transform the image with angle = 0
    imshow(fftshift(reconstructed_image_by_spectrum) , []);
    title("Reconstruction using only the spectrum");
    subplot(235);
    reconstructed_image_by_rectangle_spectrum = ifft2(fft_image .* abs(fft_rectangle) ./ abs(fft_image));
    imshow(reconstructed_image_by_rectangle_spectrum , []);
    title("Reconstruction using spectrum of rectangle and phase of image");
    subplot(236);
    reconstructed_image_by_rectangle_phase = ifft2(fft_rectangle .* abs(fft_image) ./ abs(fft_rectangle));
    imshow(reconstructed_image_by_rectangle_phase , []);
    title("Reconstruction using phase of rectangle and spectrum of image");
end

function output = rectangle(image_width, image_height, width, height)
    % Description : create a white rectangle in a black background
    % Inputs :
    %           image_width : the final output width
    %           image_height : the final output height
    %           width : the rectangle width
    %           height : the rectangle height
    % Outputs : 
    %           output : output image
    
    output = zeros(image_height, image_width, 'uint8');
    i_center = int16((image_height - height)/2);
    j_center = int16((image_width - width)/2);
    for i=i_center + 1:i_center + height - 1
        for j=j_center + 1:j_center + width - 1
            output(i,j) = 255;
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
    output = zeros(dim(1), dim(2), 'double');
    for i=1:dim(1)
        for j=1:dim(2)
            if(mod(i - 1 + j - 1, 2) == 0)
                output(i,j) = image(i,j);
            else
                output(i, j) = -1 * double(image(i,j));
            end
        end
    end
end

function output = scale(image)
    % Description : scale a image to show as image in uint8
    % Inputs :
    %       image : main image
    % Outputs:
    %       output: image after being scaled
    scaled = double(image) - min(min(image));
    scaled = scaled * 255 / max(max(image));
    output = uint8(scaled);
end

function output = warp_image(image, affine_matrix)
    % Description : warp (affine transform) image
    % Inputs : 
    %       image : main image
    %       affine_matrix : transform matrix
    % Outputs :
    %       output : image after being transformed
    dim = size(image);
    if(affine_matrix(1,3) == 0 && affine_matrix(2,3) == 0) % pure rotation
        output = imtransform(image, maketform('affine', affine_matrix'));
    elseif(affine_matrix(1,2) == 0 && affine_matrix(1,1) == 1 && affine_matrix(2,1) == 0 && affine_matrix(2,2) == 1)
        output = imtransform(image, maketform('affine', affine_matrix'),...
            'XData',[1 size(image,2)],'YData',[1 size(image,1)]);
    else
        output = imtransform(image, maketform('affine', affine_matrix'));
    end
end