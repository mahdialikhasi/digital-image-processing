function main
    % read image
    image = imread("Fig0354(a)(einstein_orig).tif");
    
    [dark_x, dark_y, gray_x, gray_y, bright_x, bright_y, vd, vg, vb] = get_input();
    z = fuzzy_enhancement(dark_x, dark_y, gray_x, gray_y, bright_x, bright_y, vd, vg, vb);
    
    fuzzyfied_image = intensity_transform(image, z);
    equalized_image = histeq(image);
    
    % figure 3.54
    figure;
    subplot(131);
    imshow(image);
    title("Main image");
    subplot(132);
    imshow(equalized_image);
    title("Histogram Equalizer");
    subplot(133);
    imshow(fuzzyfied_image);
    title("Fuzzy enhancement");
    
    % figure 3.55
    figure;
    subplot(221);
    histogram(image);
    title("Histogram of main image");
    subplot(222);
    histogram(equalized_image);
    title("Histogram of equalized image");
    subplot(223);
    axis([0 255 0 1]);
    histogram(image);
    image_histogram = imhist(image);
    hold on;
    line(dark_x, max(image_histogram)*dark_y);
    line(gray_x, max(image_histogram)*gray_y);
    line(bright_x, max(image_histogram)*bright_y);
    title("Membership functions");
    subplot(224);
    histogram(fuzzyfied_image);
    title("Histogram of fuzzy image result");
    
end

function output = fuzzy_enhancement(dark_x, dark_y, gray_x, gray_y, bright_x, bright_y, vd, vg, vb)
    % Description : Run fuzzy enhancement algorithm for intensity mapping
    % Inputs :
    %       dark_x, dark_y : The membership function of dark part
    %       gray_x, gray_y : The membership function of gray part
    %       bright_x, bright_y : The membership function of bright part
    %       vd, vg, vb : Membership functions of outputs
    % Outputs:
    %       output : Intensity mapping function

    output = zeros(256, 1, "uint8");
    for i=0:255
        if(i > dark_x(size(dark_x)))
            m_d = 0;
        else
            m_d = interp1(dark_x, dark_y, i);
        end
        d = size(gray_x);
        if(i < gray_x(1) || i > gray_x(d(1)))
            m_g = 0;
        else
            m_g = interp1(gray_x, gray_y, i);
        end
        if(i < bright_x(1))
            m_b = 0;
        else
            m_b = interp1(bright_x, bright_y, i);
        end
        
        output(i+1) = (m_d * vd + m_g * vg + m_b * vb) / (m_d + m_g + m_b);
    end
end

function [dark_x, dark_y, gray_x, gray_y, bright_x, bright_y, vd, vg, vb] = get_input()
    % Description : Get membership functions of fuzzy enhancement from user
    % Inputs:
    % Outputs :
    %       dark_x, dark_y : The membership function of dark part
    %       gray_x, gray_y : The membership function of gray part
    %       bright_x, bright_y : The membership function of bright part
    %       vd, vg, vb : Membership functions of outputs
    
    figure;
    axis([0 255 0 1]);
    title("Please Enter dark member function for input pixel. Press enter for end");
    [dark_x, dark_y] = ginput();
    d = size(dark_x);
    dark_x = [0; dark_x; dark_x(d(1)) + 1];
    dark_y = [1; dark_y; 0];
    close all;
    
    figure;
    axis([0 255 0 1]);
    title("Please Enter gray member function for input pixel. Press enter for end");
    [gray_x, gray_y] = ginput();
    d = size(gray_x);
    gray_x = [gray_x(1) - 1; gray_x; gray_x(d(1)) + 1];
    gray_y = [0; gray_y; 0];
    close all;
    
    figure;
    axis([0 255 0 1]);
    title("Please Enter bright member function for input pixel. Press enter for end");
    [bright_x, bright_y] = ginput();
    bright_x = [bright_x(1) - 1 ;bright_x; 255];
    bright_y = [0; bright_y; 1];
    close all;
    
    vd = input("Please enter output member function of dark part : ");
    vg = input("Please enter output member function of gray part : ");
    vb = input("Please enter output member function of bright part : ");
    
    figure;
    axis([0 255 0 1]);
    line(dark_x, dark_y);
    line(gray_x, gray_y);
    line(bright_x, bright_y);
end

function output = intensity_transform(image, z)
    % Description : Apply Intensity transform function on an image
    % Inputs :
    %           image : main image
    %           z : intensity transform function
    % Outpus :
    %           output : Image after applying trnasform function
    
    dim = size(image);
    output = zeros(dim(1), dim(2), "uint8");
    for i=1:dim(1)
        for j=1:dim(2)
            output(i, j) = z(image(i, j) + 1);
        end
    end
end