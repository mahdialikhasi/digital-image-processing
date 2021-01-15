## Problem 1
Download an image suitable for applying Momomorphic filter.

### Part a
Write a function to design a filter as given in Eq.4.9-29. As parameters to this function, pass ʎH, ʎL and the image.

### Part b
Apply homomorphic filter by following the steps given in Fig.4.60. Display the input and output images in one window, next to each other with appropriate heading messages. 

In the messages, write the values of ʎH, ʎL.

Note: you should not call Matlab function to perform this filter. But you can only call FFT and inverse FFT of Matlab.

## Problem 2
Download a standard image.

### Part a
Add periodic noise (by calling a Matlab function) different from that of Ex.2, such that the noisy image looks like Fig.4.64.a. Show the original, noisy and the spectrum images.

### Part b
Manually design a notch filter appropriate for your example (i.e. as shown in Fig.4.64.b). To design this filter you can use Photoshop or Microsoft Paint. Apply the filter on image, and display the final noise removed (filtered) image.

## Problem 3
Draw a binary pattern of an airplane (using Paint or Ph0toshop).

### Part a
Write a function to extract the (x,y) coordinate of all pixels belonging to the object.

### Part b
Perform PCA by calculating the mean and covariance matrices as described in section 11.4.

### Part c
Compute eigenvalues, eigenvectors, etc, and show the 4 images similar to those shown in Fig.11.43.

Note: In (a) you should write a function to read the graphical image you designed, and extract its vectors. These vectors are the input to the next functions, to compute mean, covariance, eigenvalues and eigenvectors you can call Matlab function, but you are not allowed to call PCA of Matlab.