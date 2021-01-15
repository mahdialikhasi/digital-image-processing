function main
  img = imread('Orion_Belt.jpg');
  dim = size(img);  
  image_averaging(img, 40, 5);
  
  image_averaging(img, 40, 10);
  
  image_averaging(img, 40, 50);
  
  image_averaging(img, 40, 100);
end


function image_averaging(img, variance, times)
  % Add random gussian noise to the image
  % Average from noisy images to remove noise
  % show histogram and images of noisy and averaged image
  % Input :
  %    img : Input image
  %    variance : The variance of gussian noise
  %    times : the number of noisy images we want to produce
  dim = size(img);
  new_image = zeros(dim(1), dim(2), 'double');
  img = double(img);
  for i = 1: times
    noisy = img + normrnd(0,variance,dim(1),dim(2));
    new_image = new_image + noisy;
  end
  noisy = uint8(noisy);
  averaged = uint8(new_image ./ times);
  figure;
  imshow(noisy);
  title(strcat("Noisy Image : ", num2str(times)));
  figure;
  imshow(averaged);
  title(strcat("Averaged Image : ", num2str(times)));

  figure;
  imhist(noisy);
  title(strcat("histogram of noisy : ", num2str(times)));

  figure;
  imhist(averaged);
  title(strcat("histogram of averaged : ", num2str(times)));
end