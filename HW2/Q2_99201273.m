function main
    % read image
    img = imread("image.jpg");    
    gray = rgb2gray(img);
    dim = size(gray);
    
    % histgram equalization the image
    img_equalized = histogram_equalization(gray);
    
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
    
    % compare with matlab histogram equalizer
    img_matlab_eq = histeq(gray);
    figure;
    diff = img_equalized - img_matlab_eq;
    imshow(diff,[]);
    title("show the difference image");
    disp("image size is : ");
    disp(dim);
    disp("The summation of pixel wise absolute difference is :");
    disp(sum(sum(abs(double(img_equalized) - double(img_matlab_eq)))));
    disp("The average of pixel wise absolute difference is :");
    disp(sum(sum(abs(double(img_equalized) - double(img_matlab_eq)))) / (dim(1) * dim(2)));

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