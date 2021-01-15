function main
    % read the image
    img = imread("wp2301572-anime-4k-wallpapers.jpg");
    gray = rgb2gray(img);
    
    % get a new histogram specification from user
    [x, y] = create_histogram_transformation(gray);
    
    figure;
    subplot(221);
    imshow(gray);
    title("Main image");
    
    % calculate density distribution function of main image
    s = histogram_density_image(gray);
    disp("Density distribution function of main image is : ");
    disp(s);
    
    % calculate density distribution of target image
    v = histogram_density(x, y);
    disp("Density distribution function of target image is : ");
    disp(v);
    
    % Run histogram specification base on V and S (Density functions of main and target images)
    disp("Run histogram specification base on V and S (Density functions of main and target images)");
    z = histogram_specification(s, v);
    disp(z);
    
    subplot(223);
    histogram(gray);
    title("Histogram of main image");
    
    transform = histogram_transform(gray, z);
    subplot(222);
    imshow(transform);
    title("Transformed image");
    
    subplot(224);
    histogram(transform);
    title("Histogram of target image");
end

function [x, y] = create_histogram_transformation(image)
    % Description : draw an image's histogram and input from user a new
    % histogram specification
    % function
    % Inputs:
    %       image : The main image which its histogram will be display
    % Output:
    %       x : an array of points' x axis which user has selected
    %       y : an array of points' y axis which user has selected
    
    figure;
    histogram(image);
    title("please select points respectively to draw a new histogram specification. press enter for end.");
    [x, y] = ginput();
    if(x(1) ~= 0)
        x = [0; x];
        y = [y(1); y];
    end
    dim = size(x);
    if(x(dim(1)) ~= 255)
        x = [x; 255];
        y = [y; y(dim(1))];
    end
    line(x,y);
end


function output = histogram_density_image(image)
    % Description : Histogram density calculator. First count the
    % probability of each intensity level. After that calculates the
    % accumulative probability and use that as intensity transform function
    % Inputs:
    %       image: the main image which we want to run our algorithm on
    % Outputs:
    %       output: equalized histogram (S)
    
    probability = zeros(256, 1, "double");
    dim = size(image);
    for i=1:dim(1)
        for j=1:dim(2)
            probability(image(i,j) + 1) = probability(image(i,j) + 1) + 1;
        end
    end
    probability = probability ./ (dim(1) * dim(2));
    
    acc_probability = zeros(256, 1, "double");
    acc_probability(1) = probability(1);
    for i=2:256
        acc_probability(i) = probability(i) + acc_probability(i - 1);
    end
    
    output = uint8(acc_probability .* 255);
end

function output = histogram_density(x, y)
    % Description : Calculate density function of a given histogram
    % Inputs :
    %       x : x axis of points of histogram
    %       y : y axis of points of histogram
    % Outpus :
    %       output : density function
    
    count = zeros(256, 1, "double");
    for i=0:255
        count(i + 1) = interp1(x,y,i);
    end
    output = double(count ./ sum(count));
    
    for i=2:256
        output(i) = output(i) + output(i - 1);
    end
    output = uint8(output .* 255);
end

function z = histogram_specification(s, v)
    % Description : Run histogram specification algorithm base on main
    % image density and target image density
    % Inputs :
    %           s : main image density function
    %           v : target image density function
    % Outputs:
    %           z : calculate V_inv(s)
    
    z = zeros(256, 1, "uint8");
    for i=1:256
        value = s(i);
        min = 255;
        index = 1;
        for j=1:256
            if(abs(int16(v(j)) - int16(value)) < min)
                index = j;
                min = abs(int16(v(j)) - int16(value)) ;
            end
        end
        z(i) = index - 1;
    end
end

function output = histogram_transform(image, z)
    % Description : Transform image intensity level base on a transform
    % function
    % Inputs :
    %       image : main image
    %       z : intensity transform function
    % Outputs :
    %       output : Transformed image
    
    dim = size(image);
    output = zeros(dim(1), dim(2), "uint8");
    
    for i=1:dim(1)
        for j=1:dim(2)
            output(i,j) = z(image(i,j) + 1);
        end
    end
end