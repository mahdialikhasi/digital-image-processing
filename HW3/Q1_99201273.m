function main
    % input and parse the filter from user
    filter = input("Please enter filter elements (a1 to a9) comma seperated and column wise : ", "s");
    array = str2num(regexprep(filter,',',' '));
    filter = reshape(array, 3, 3);
    
    % normalize filter
    s = (sum(sum(filter)));
    if(s ~= 0)
        filter = double(filter / s);
    else
        filter = double(filter);
    end
    
    % read the image to apply the filter
    img = imread("Fig0333(a)(test_pattern_blurring_orig).tif");
    conv_result = convolution(img, filter);
    
    % show image
    figure;
    subplot(121);
    imshow(img);
    title("Main image");
    subplot(122);
    imshow(uint8(conv_result));
    title("After applying filter (My function)");

    
    % run matlab convolution
    conv_result_matlab = conv2(img, filter, 'same');
    
    % show image
    figure;
    subplot(121);
    imshow(img);
    title("Main image");
    subplot(122);
    imshow(uint8(conv_result_matlab));
    title("After applying filter (Matlab Function)");
    
    figure;
    diff = conv_result_matlab - conv_result;
    imshow(uint8(diff));
    title("Differenece");
    
    disp("Max Absolute Difference : ");
    disp(max(max(abs(diff))));
end


function output = corrolation(image, filter)
    % Description : Apply filter corrolation on image
    % Inputs:
    %       image: the main image which we want to run our algorithm on
    %       filter : the filter which will be applied on image
    % Outputs:
    %       output: the image after applying filter on it
    
    dim = size(image);
    output = zeros(dim(1), dim(2), "double");
    filter_size = size(filter);
    
    % Pad image
    image = padarray(image, double([floor(filter_size(1)/2) floor(filter_size(2)/2)]));
    
    % apply corrolation
    for i=1:dim(1)
        for j=1:dim(2)
            tmp = double(image(i:i+filter_size(1)-1, j:j+filter_size(2)-1));
            conv = tmp .* filter;
            output(i,j) = sum(sum(conv));
        end
    end
end

function output = convolution(image, filter)
    % Description : Apply filter convolution on image
    % Inputs:
    %       image: the main image which we want to run our algorithm on
    %       filter : the filter which will be applied on image
    % Outputs:
    %       output: the image after applying filter on it
    
    filter = corrolation([0,0,0;0,1,0;0,0,0], filter);
    output = corrolation(image, filter);
end