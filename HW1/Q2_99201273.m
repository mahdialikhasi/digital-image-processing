function main
  img = imread('image.jpg');
  dim = size(img);
  grayscale = rgb2gray(img);  

  s = resize(grayscale, 512, 512);
  figure;
  imshow(quantization(s, 256));
  title("256 level of quantization");

  figure;
  imshow(quantization(s, 128));
  title("128 level of quantization");

  figure;
  imshow(quantization(s, 64));
  title("64 level of quantization");

  figure;
  imshow(quantization(s, 32));
  title("32 level of quantization");

  figure;
  imshow(quantization(s, 2));
  title("2 level of quantization");  
end


function resized_image = resize(img, width, height)
  % resize the image base on input width and height
  % the function uses nearest neighbour methos
  % first find the scale, and then base on the scale, find nearest pixel in
  % input image for each pixel of output image
  % Inputs :
  %   img : the image we want to resize
  %   width : output width of resized image
  %   height : output height of resized image
  % Outputs:
  %   resized_image : resized image
  
  dim = size(img);
  w_size = dim(2) / width;
  h_size = dim(1) / height;

  resized_image = zeros(height, width, 'uint8');
  for i = 1:height
    for j = 1:width
      resized_image(i,j) = uint8(img(int16(i * h_size), int16(j * w_size)));
    end
  end
end

function quant = quantization(img, level)
  % change the level of quantilization
  % first find the number of bits to remove by log
  % then remove the necessary bits using shift methods
  % Inputs :
  %   img : The image we want to change its quantization level
  %   level : The number of quantization levels
  % Output :
  %   quant : The output image after quntization
  dim = size(img);
  quant = zeros(dim(1), dim(2), 'uint8');
  l = 8 - log2(level);
  for i = 1:dim(1)
    for j = 1:dim(2)
      quant(i,j) = uint8(bitshift(bitshift(img(i,j),-l), l));
    end
  end
end
