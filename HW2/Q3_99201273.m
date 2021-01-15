function main
    % read image and create transform function from user
    image_file = input("Please enter image file name : ", 's');
    gray = imread(image_file);    
    % gray = rgb2gray(gray);
    window_size = input("Please enter the window size : ");
    
    img_equalized = local_histogram_equalization(gray, window_size);
    
    % showing image and its histogram
    figure;
    subplot(221);
    imshow(gray);
    title("main image");
    subplot(222);
    imshow(img_equalized);
    title("image after histogram equalization");
    subplot(223);
    histogram(gray);
    title("main image histogram");
    subplot(224);
    histogram(img_equalized);
    title("the histogram of image after histogram equalization");
end

function output = local_histogram_equalization(image, window_size)
    % Description : Local Histogram equalizer algorithm. First zero padding
    % base on window_size and then each time compute the histogram
    % equalizer in a given window
    % Inputs:
    %       image: the main image which we want to run our algorithm on
    %       window_size : window size of local histogram
    % Outputs:
    %       output: the image after histogram equalization algorithm
    
    if(mod(window_size, 2) == 0)
        window_size = window_size + 1;
    end
    dim = size(image);
    output = zeros(dim(1), dim(2), "uint8");
    pad = (window_size - 1)/2;
    image = padarray(image, [pad pad]);
    
    for i=1:dim(1)
        for j=1:dim(2)
            tmp = image(i:i+window_size-1, j:j+window_size-1);
            hist = histeq(tmp);
            output(i,j) = hist(pad + 1,pad + 1);
        end
    end
end

function output = histogram_equalization(image)
    % Description : Histogram equalizer algorithm. First count the
    % probability of each intensity level. After that calculates the
    % accumulative probability and use that as intensity transform function
    % Inputs:
    %       image: the main image which we want to run our algorithm on
    % Outputs:
    %       output: the image after histogram equalization algorithm
    
    probability = zeros(256, 1, "double");
    dim = size(image);
    for i=1:dim(1)
        for j=1:dim(2)
            probability(image(i,j) + 1) = probability(image(i,j) + 1) + 1;
        end
    end
    probability = probability ./ (dim(1) * dim(2));
    
    % Compute accumulative probability
    acc_probability = zeros(256, 1, "double");
    acc_probability(1) = probability(1);
    for i=2:size(acc_probability)
        acc_probability(i) = probability(i) + acc_probability(i - 1);
    end
    
    output = zeros(dim(1), dim(2), "uint8");
    for i=1:dim(1)
        for j=1:dim(2)
            output(i,j) = acc_probability(image(i,j) + 1) * 255;
        end
    end
end