## Problem 1
Download a high resolution color image (at least 10 mega pixels).
- Convert it to its grayscale version.
- Redisplay the same image with a given dpi (1200, 600, 300, 150, 75) that you read from input.
- Display as title, the dpi on top of the output image.
- Note, you can use MATLAB instruction for this exercise.

## Problem 2
- Use the same grayscale image of Exercise 1, resize it to 512x512, then display it with 256, 128, 64, 32 and 2 levels of quantization.
- Note that you should not use the resize and quantization instructions of MATLAB.
- For resize use pixel replication method, and for quantization, write your own code.

## Problem 3
- Download an astronomical image with size at least 5152x512.
- Make a copy of the original image, add Gaussian noise of mean zero and selected variance to the copy version. Repeat the procedure of noise addition, 5, 10, 50 and 100 times. For each number of noise additions perform image averaging to reduce noise.
- For each case, display the noisy image, averaged image, histogram of noisy and averaged image.
- Note: you can use the MATLAB instructions to do this exercise.

## Problem 4
- Download a scenery image, if it is color, convert it to gray scale.
- Define a Shear operation affine transform. Apply the shear transform on the image. (Use MATLAB function). The shearing parameters should be input by the user.
- Move the mouse around on both, original and the transformed image and manually select 4 control points on each image.
- Using these 4 control points, define equations (2.6-24) and (2.6-25) in chapter 2, to calculate the c1 ~ c8 coefficients. Note, you can use MATLAB or other packages to solve the set of 8 linear equations.
- Using these 8 coefficients, transform the degraded image (the output of affine transform) to its registered version.
- Display the 4 images with the description given in Fig.2.37 of chapter 2.