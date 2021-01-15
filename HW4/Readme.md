## Problem 1
Download an image similar to Fig.4.17 that has some texture like the objects in this image.

### Part a
Produce an image 50% of the size of input image (by size I mean total area of image) by row-column deletion.

### Part b
Resize the output in (a) input to image original size using linear interpolation.

### Part c
Apply 3x3 mean filter on original image prior to size reduction. Repeat steps a) and b).

### Part d
Show, the original, reduced size and interpolated images in b) and c) in 4 windows. You should be able to see the aliasing effects in images produced in (b) and (c).

## Problem 2
Download a standard image of image processing. Construct an image of a rectangle, the same size as downloaded image that looks line fig.4.24(a).

### Part a
Show the spectrum of rectangle image without and then with multiplying it to (-1) ^ (x+Y) before FFT calculation. Show the original image and two spectrums as Fig.4.24.b and 4.24.d.

### Part b
Translate and rotate the rectangle image, the function should receive these parameters as its input. Then show the spectrums as fig.4.25.

### Part c
Show the phase angle images in 3 states as shown in Fig. 4.26.

### Part d
Produce the output as of Fig.4.27 with the download standard image and the rectangle image.

## Problem 3
Use the standard image downloaded in Ex.2. Design a symmetric filter function H(u,v).

Follow the 7 steps described in section 4.7.3 to filter the input image using the H(u,v).

Note: your program should have 7 steps as shown in section 4.7.3.

## Problem 4
Design ideal, Gaussian and Butterworth low-pass filters, such that you can define a single D0 for all three filters.

### Part a
Call a function 3 times each time with a different D0 parameter corresponding to 80, 90 and 95 percent of power spectrum. (Note: D0 should be calculated accordingly). Another parameter is needed for the order of butterworth filter.

### Part b
For each D0, display the original and 3 filtered images. On top of each filtered image display filter type, D0 value and the order of butterworth filter. For each D0 value,calculate and display 3 images that are the difference between the original image and the filtered image to compare the performance of 3 filtering method.