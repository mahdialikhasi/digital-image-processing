## Problem 1
### Part a
Develop a graphical interface to draw a transform function as shown in Fig.3-10 (a).

For example if you were supposed to produce exactly Fig.10(a), you should right-click on mouse at points (r1,s1) and (r2,s2) only. When the point selection procedure is finished, you can decide the termination process by for example clicking on an icon that you design, or simply double left-click.

By default, (0,0) will be collected to the first selected point, and the last selected point will be connected to point (255,255). Upon termination of this routine, the shape of transform function T(r ) should be displayed.

Using this routine you should be able to define any shape of transformation function.

### Part b
Design one transform function similar to Fig.3.10(a) and another one similar to Fig.3.11(c).

### Part c
read two images, apply the above transform functions to them, and show, transform function, input and output images on 3 separate windows.

## Problem 2
Write your own code to implement Histogram equalization. Noe that you are not supposed to call the function provided in Matlab. Compare the output image of your code with that of Matlab, by displaying the difference of two output images and also the summation of absolute value of pixel-wise differences between these two images.

## Problem 3
Use Matlab histogram equalization function to apply local histogram equalization with a given window size. Image name and window size are two input parameters to this function. You should write two nested loop to move on original image, and at each position, calculate histogram equalization.

## Problem 4
Write an interface to design the overall shape of a histogram for histogram specification routine.

Download an image and display its histogram, the graphical shape of histogram you design should be very similar to the histogram of this image but with some significant modifications.

As output, you should show the process of designing new histogram, the final version of histogram, the original and the result of applying histogram specification.

Note: you are not supposed to call the Matlab function for histogram specification, but should write your own code.