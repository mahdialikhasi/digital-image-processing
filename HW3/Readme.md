## Problem 1
Design a 3x3 filter such that you can input its cell values within the program.
### Part a
Read an image, write a program that performs convolution of the image and the
above mentioned 3x3 filter. Use the two smoothing filters as Fig. 3.22 (a and b), show the output.

Note: In your convolution program you should consider zero padding.

Apply the same filters by calling Matlab functions, compare the output of two cases by calculating the difference image and display the absolute difference values of the two output images.

### Part b
Design both vertical and horizontal 3x3 Sobel and Prewitt filters as mentioned above and repeat the procedure in (a).


## Problem 2
Read an image.

### Part a
Write a function to add salt and pepper noise to this image. As a parameter input the percentage (a number between 10 ~ 95) that indicates the percentage of number of pixels in the image which gray levels will be replaced by 0 or 255. You should write the program which calls a random number generator to generate a salt or pepper noise (255 or 0), another 2 random variables for (x, y) to define the location in image where its gray level should be replaced by 0 or 255.
### Part b
Call Matlab median filter to remove the salt and pepper noise, with widow size of 3x3 and 5x5.

### Part c
Write a program that if the median gray value in a 3x3, 5x5, ... 15x15 is a noise, increase the window size and check if the new median is not noise, then replace it. This routine continues until reaching the maximum window size of 17x17.

### Part d
Write a function for Alpha trimmed filter which has the Alpha, window size and the noisy images as its input, and the noise removed image as its output.

## Problem 3
Read an image,
- Apply the unsharp masking on it as follows: You can use the Matlab functions
- Blur the image using a 3x3 mask.
- Subtract the blurred image form the original to generate a mask.
- Add the mask to the original.
- You should produce all 5 images as shown in Fig,3.38.

## Problem 4
Read an image that looks like Fig.3.54 (a), Implement fuzzy image enhancement, as section 3.8.4

### Part a
Develop a function using which you can define several piecewise linear functions to be used as input and output fuzzy membership functions, same as Fig. 3.53
### Part b
As output you should produce the same sequence of images and figs shown in
Fig.3.54 and 3.55.

Note: For every gray level in the histogram of the input image, you should find an output gray level using the fuzzy enhancement. Then enhance the image.