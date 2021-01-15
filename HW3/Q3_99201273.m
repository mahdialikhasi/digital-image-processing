function main
    % read image
    img = imread("DIP3E_Original_Images_CH03\Fig0340(a)(dipxe_text).tif");
    
    % print main image
    figure;
    subplot(321);
    imshow(img);
    title("Main image");
    
    unsharp_masked_image = unsharp_mask(img, 2);
end

function output = unsharp_mask(image, k)
    % Description : apply unsharp filtering on image
    % step 1 : blur image
    % step 2 : subtract blured image from original image (create mask)
    % step 3 : add mask to original image
    % Inputs : 
    %       image : main image
    % Outputs : 
    %       output : image after unsharp filtering
    
    output = image;
    % step 1
    blur = conv2(image, ones(3,3,"double") / 9, "same");
    subplot(322);
    imshow(uint8(blur));
    title("Blured image");
    
    % step 2
    mask = double(image) - blur;
    mask = uint8(mask - min(min(mask)));
    subplot(323);
    imshow(mask);
    title("unsharp mask");
    
    subplot(324);
    unsharp_masked = output + mask;
    imshow(unsharp_masked);
    title("result of using unsharp mask");
    
    output = output + k * mask;
    subplot(325);
    imshow(output);
    title("result of using highboost filtering");
end