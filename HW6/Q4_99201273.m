function main
    image = imread("Fig0526(a)(original_DIP).tif");
    
    [blurred, H] = part_one(image);
    part_two(blurred, H);
    part_three(blurred, H);
end

function [output, H] = part_one(image)
    % Description : Apply linear motion blur to an image.
    % This function uses parameters like a and b that identifies
    % the motion directions in x , y
    % Inputs : 
    %           image : main image
    % Outputs:
    %           output : blurred image
    %           H : Motion blur function
    
    a = 0.1;
    b = 0.1;
    t = 1;
    
    % motion blur
    [output, H] = matlab_motion_blur(image, a, b, t);
    
    % Plot
    figure;
    subplot(121);
    imshow(image);
    title("Main image");
    subplot(122);
    imshow(output, []);
    title("blurred image : a = " + num2str(a) + ", b = " + num2str(b) + ", t = " + num2str(t));
end

function part_two(blurred, H)
    % Description : Perform Winner filter on motion blur image to restore it. Show the restored image
    % Inputs:
    %           blurred : blurred image
    %           H : Degenerating function
    
    wnr3 = deconvwnr(blurred, H, 0.0001);
    figure;
    subplot(121);
    imshow(blurred);
    title("blurred Image");
    subplot(122);
    imshow(wnr3);
    title('Restoration of Blurred');
end

function part_three(blurred, H)
    % Description : Apply Gaussian noise on the motion blurred image. Then try to restore it
    
    % Inputs:
    %           blurred : blurred image
    %           H : Degenerating function
    
    
    % add noise
    mean = 0;
    variance = 0.001;
    blurred_noisy = imnoise(blurred, 'gaussian', mean, variance);
    
    % remove noise
    k = 0.002;
    wnr3 = deconvwnr(blurred_noisy, H, k);
    
    % Plot
    figure;
    subplot(121);
    imshow(blurred_noisy);
    title('Blurred noisy image');
    subplot(122);
    imshow(wnr3);
    title('Restoration of Blurred');
end

function [output, H] = matlab_motion_blur(image, a, b, t)
    % Description : apply motion blur to an image
    % Inputs :
    %       image : main image
    %       a : speed in x direction
    %       b : speed in y direction
    %       t : duration
    % Outpus:
    %       output : blurred image
    %       H : Motion blur function
    
    H = fspecial('motion',500 * sqrt((a * t) ^ 2 + (b * t) ^ 2),atand(-a/b));
    output = imfilter(image, H, 'conv', 'circular');
end

function output = motion_blur(image, a, b, t)
    % Description : apply motion blur to an image
    % Inputs :
    %       image : main image
    %       a : speed in x direction
    %       b : speed in y direction
    %       t : duration
    % Outpus:
    %       output : blurred image
    
    % fourie transform
    image_p = padarray(image, [size(image, 1) size(image, 2)], 'post');
    image_fft = fft2(image_p);
    
    % motion blur function
    H = complex(zeros(size(image, 1) * 2, size(image, 2) * 2));
    
    for v=1:size(image, 1)*2
        for u=1:size(image, 2) * 2
            tmp = pi * (u*a + v*b);
            H(v, u) = (t / tmp) * sin(tmp) * exp(-j * tmp);
        end
    end
    
    % apply filter
    G = H .* image_fft;
    g = ifft2(G);
    output = abs(g(1:size(image, 1), 1:size(image, 2)));
end