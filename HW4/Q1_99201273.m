function main
    % read image
    image = imread("Fig0417(a)(barbara).tif");
    
    % part a and b
    % shrink image to have 1/2 of area
    shrinked_image = image_shrink(image, sqrt(2), sqrt(2));
    
    % resize image to main size
    resized_image = imresize(shrinked_image ,sqrt(2),'bilinear');
    
    % plot
    figure;
    subplot(131);
    imshow(image);
    title("main image");
    subplot(132);
    imshow(shrinked_image);
    title("reduced image");
    subplot(133);
    imshow(resized_image);
    title("bilinear interpolation");
    
    % part c
    % apply mean filter
    smooth_image = uint8(conv2(image, ones(3,3,"double")/9, 'same'));
    
    % shrink image
    smooth_shrinked_image = image_shrink(smooth_image, sqrt(2), sqrt(2));
    
    % resize image to main size
    smooth_resized_image = imresize(smooth_shrinked_image, sqrt(2), 'bilinear');
    
    % plot
    figure;
    subplot(131);
    imshow(image);
    title("main image");
    subplot(132);
    imshow(smooth_shrinked_image);
    title("reduced image (after smoothing)");
    subplot(133);
    imshow(smooth_resized_image);
    title("bilinear interpolation (after smoothing main image)");
end

function output = image_shrink(image, row_step, col_step)
    % Description : shrink image to a smaller size
    % Inputs :
    %       image : main image which will be shrinked
    %       row_step : the deleting step along y axis. must be greater than
    %       one. For example if the step is equal to 3, the resulting image
    %       will be one third of main image in size
    %       col_step : the deleting step along x axis. must be greater than
    %       one
    % Outpus :
    %       output : shrinked image
    
    dim = size(image);
    rows = floor(1:row_step:dim(1));
    cols = floor(1:col_step:dim(2)); % indexes of main image which will be preserved
    output = zeros(length(rows), length(cols), "uint8");
    i_counter = 0;
    for i=rows
        j_counter = 0;
        i_counter = i_counter + 1;
        for j=cols
            j_counter = j_counter + 1;
            output(i_counter, j_counter) = image(i, j);
        end
    end
end