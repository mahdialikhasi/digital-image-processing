function main
    % read image
    img = imread("Fig0222(a)(face).tif");
    percent = input("please enter a noise percent (between 10 and 95) : ");
    percent = uint8(percent);
    
    noisy_image = salt_pepper(img, percent);
    
    % print noisy image
    figure;
    subplot(221);
    imshow(img);
    title("Main image");
    subplot(222);
    imshow(noisy_image);
    title("Noisy image");
    
    % print image after applying median filter
    subplot(223);
    imshow(medfilt2(noisy_image, [3 3]));
    title("Noise removed with median filter 3*3");
    subplot(224);
    imshow(medfilt2(noisy_image, [5 5]));
    title("Noise removed with median filter 5*5");
    
    % Part c : increase window size
    % print noisy image
    figure;
    subplot(221);
    imshow(img);
    title("Main image");
    subplot(222);
    imshow(noisy_image);
    title("Noisy image");
    
    % print image after applying median filter
    subplot(223);
    imshow(scalable_median_filter(noisy_image));
    title("Noise removed with scalable median filter");
    
    % Pard d
    noisy_image2 = input("Please enter image file address : ", "s");
    noisy_image2 = imread(noisy_image2);
    window_size = input("Please enter window size : ");
    alpha = input("Please enter alpha (alpha should be less than half of window_size ^ 2) : ");
    
    % print
    figure;
    subplot(121);
    imshow(noisy_image2);
    title("Noisy image");
    
    % print image after applying median filter
    subplot(122);
    imshow(alpha_trim(noisy_image2, window_size, alpha));
    title("Noise removed with alpha trim");
end

function noisy_image = salt_pepper(image, percent)
    % Description : Read an image and add random salt and pepper noise to
    % it
    % Inputs : 
    %       image : main image
    %       percent : percent of noisy which will be added
    % Outputs : 
    %       noisy_image : image after adding noise
    
    dim = size(image);
    noisy_image = image;
    count = (dim(1)*dim(2)*double(percent))/100;
    % craete a random permutation of all pixels
    rand_perm = randperm(dim(1) * dim(2));
    [y, x] = ind2sub([dim(1) dim(2)],rand_perm(1:count));
    for i=1:count
        % choose a random int which indicates type of noise. salt or pepper
        noise_type = uint8(round(rand) * 255);
        noisy_image(y(i),x(i)) = noise_type;
    end
end

function output = scalable_median_filter(image)
    % Description : run median filter on image with windows size of 3*3 and
    % if the return result is noise, increases the window size
    % Inputs:
    %       image : input image
    % Output:
    %       output: denoised image
    dim = size(image);
    output = zeros(dim(1), dim(2), "uint8");
    image = padarray(image, [17 17]);
    for i=1:dim(1)
        for j=1:dim(2)
            index_i = i + 17;
            index_j = j + 17;
            for k=1:8
                window_size = k*2+1;
                pad = (window_size - 1) / 2;
                t = image(index_i-pad:index_i+pad, index_j-pad:index_j+pad);
                t = reshape(t, 1, []);
                t = sort(t);
                element = uint8((window_size * window_size) / 2);
                value = t(element);
                if(t(element) ~= 0 && t(element) ~= 255)
                    break;
                end
            end
            output(i, j) = value;
        end
    end
end

function output = alpha_trim(image, window_size, alpha)
    % Description : run alpha trim filter on image
    % Inputs:
    %       image : input image
    %       window_size : filter size
    %       alpha : the number of element to be removed
    % Output:
    %       output: denoised image
    dim = size(image);
    output = zeros(dim(1), dim(2), "uint8");
    if(mod(window_size, 2) == 0)
        window_size = window_size + 1;
    end
    if(mod(alpha, 2) == 1)
        alpha = alpha + 1;
    end
    % pad image
    pad = (window_size - 1) / 2;
    image = padarray(image, [pad pad]);
    for i=1:dim(1)
        for j=1:dim(2)
            % apply and sort neighbourhood
            t = image(i:i+window_size - 1, j:j+window_size-1);
            t = reshape(t, 1, []);
            t = sort(t);
            
            % trim
            s = size(t);
            t = t(alpha/2 + 1 : s(2) - alpha/2);
            
            % mean
            output(i, j) = mean(t);
        end
    end
end