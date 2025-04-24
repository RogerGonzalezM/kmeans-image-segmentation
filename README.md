# Image segmentation using K-means

This repository contains a MATLAB script for image segmentation using the K-means clustering algorithm in different feature spaces (RGB, HSV, RGBxy and HSVxy).

## Content
- **InputImage.jpg**: Default input image to perform segmentation.
- **kmeans_segmentation.m**: Main script that loads the image, extracts features, executes K-means and saves segmentations.

## Requirements
- **MATLAB R2016b** or higher (or any other compatible version with the functions used).
- Basic MATLAB toolboxes (**Statistics and Machine Learning Toolbox** optional for ***pdist2***).

## Usage
1. Clone the repository or download the files.
2. Open MATLAB and navigate to the folder containing the files.
3. Run the main function on the MATLAB command line:
	***kmeans_segmentation***

## Change the input image
By default, the script reads the image "ImageKMeans.jpg". To use another image:
1. Copy your image into the script folder.
2. Rename it or edit the ***pathImage*** variable in the ***kmeans_segmentation*** function:
   `pathImage = 'my_new_image.jpg';`
3. Make sure the image is in a compatible format (JPG, PNG, etc.).


