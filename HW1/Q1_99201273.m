function main
  img = imread('image.jpg');
  dim = size(img);  
  
  change_dpi(img, 1200);
  
  change_dpi(img, 600);
  
  change_dpi(img, 300);
  
  change_dpi(img, 150);
  
  change_dpi(img, 75);
end

function change_dpi(image, dpi)
  % change dpi of input image
  % Input:
  %   image : input image
  %   dpi : dpi
  grayscale = rgb2gray(image);
  gray_fig = figure();
  imshow(grayscale);
  title("Main image");  

  figure;
  imshow(grayscale);
  title(strcat("Image with DPI of ", num2str(dpi)));  
end
