function main
    % Part a and b
    % create transform function from user
    [x, y] = create_transform_function();
    
    % Part c 
    % read two images
    gray1 = imread("DIP3E_Original_Images_CH03\Fig0316(4)(bottom_left).tif");
    gray2 = imread("DIP3E_Original_Images_CH03\Fig0312(a)(kidney).tif");
    % gray1 = rgb2gray(img1);
    % gray2 = rgb2gray(img2);
    
    % apply transform function to first image
    display_transformed_images(gray1, x, y);
    
    waitforbuttonpress;
    close all;
    
    % apply transform function to second image
    display_transformed_images(gray2, x, y);
    
    waitforbuttonpress;
    close all;
    
    % apply transform function figure 3.10(a) to first image
    x = [0 100 150 255];
    y = [0 60 190 255];
    
    display_transformed_images(gray1, x, y);
    
    waitforbuttonpress;
    close all;
    
    % apply transform function figure 3.10(a) to second image
    display_transformed_images(gray2, x, y);
    
    waitforbuttonpress;
    close all;

    % apply transform function figure 3.11(b) to first image
    x = [0 64 65 150 151 255];
    y = [0 64 180 180 151 255];
    
    display_transformed_images(gray1, x, y);
    
    waitforbuttonpress;
    close all;
    
    % apply transform function figure 3.11(b) to second image
    display_transformed_images(gray2, x, y);
    
    waitforbuttonpress;
    close all;
    
end

function [x, y] = create_transform_function()
    % Description : paint a figure and input from user to create a intensity transform
    % function
    % Inputs:
    % Output:
    %       x : an array of points' x axis which user has selected (including 0 and 255)
    %       y : an array of points' y axis which user has selected (including 0 and 255)
    
    figure
    title("please select points respectively. press enter for end.");
    axis([0 255 0 255]);
    [x, y] = ginput();
    x = [0; x; 255];
    y = [0; y; 255];
    line(x,y);
end

function output = apply_transform_function(image, x, y)
    % Description : Get a gray scale image and apply an intensity transform on it
    % Inputs:
    %       image : the main image which we want to apply transform
    %       function on it
    %       x : the x axis part of transform function T
    %       y : the y axis part of transform function T
    % Output:
    %       output : output image after applying transform
    image = double(image);
    output = interp1(x, y, image);
    output = uint8(output);
end

function display_transformed_images(image, x, y)
    % Description : Create a figure and plot the main image, the
    % transformed image and the intensity transform function on 3 different
    % plot. This function will use linear interpolation as its transform
    % function.
    % Inputs : 
    %       image : main image
    %       x : x axis of transform function
    %       y : y axis of transform function
    
    figure;
    subplot(221);
    imshow(image);
    title("display main image");
    
    subplot(222);
    imshow(apply_transform_function(image, x, y));
    title("apply your transform");
    
    subplot(2,2,[3,4]);
    axis([0 255 0 255]);
    line(x,y);
    title("Transform Function");
end