# Image segmentation using K-means

This repository contains a MATLAB script for image segmentation using the K-means clustering algorithm in different feature spaces (RGB, HSV, RGBxy and HSVxy).

## Content
- **InputImage.jpg**: Default input image to perform segmentation.
- **kmeans_segmentation.m**: Main script that loads the image, extracts features, executes K-means and saves segmentations.
- **Output**: A folder where the generated outputs are located.

## Requirements
- **MATLAB R2016b** or higher (or any other compatible version with the functions used).
- Basic MATLAB toolboxes (**Statistics and Machine Learning Toolbox** optional for ***pdist2***).

## Usage
1. Clone the repository or download the files.
2. Open MATLAB and navigate to the folder containing the files.
3. Run the main function on the MATLAB command line:
   `kmeans_segmentation`

## Change the input image
By default, the script reads the image "ImageKMeans.jpg". To use another image:
1. Copy your image into the script folder.
2. Rename it or edit the `pathImage` variable in the ***kmeans_segmentation*** function:
   `pathImage = 'my_new_image.jpg';`
3. Make sure the image is in a compatible format (JPG, PNG, etc.).

## Configurable parameters
Within ***kmeans_segmentation.m*** you can set:
1. `ks`: vector with the values of **k** (number of clusters) to be tested. Default `ks = [2, 4, 8, 16]`.
2. `featureSpaces`: feature spaces to evaluate. Default `{'RGB', 'HSV', 'RGBxy', 'HSVxy'}`.
3. Maximum iterations and tolerance in ***kmeans_manual***: `[labels, centers] = kmeans_manual(X, k, 500, 1e-5);`

## Description
1. **Image reading**: loads and normalizes the image to floating point values between 0 and 1.
2. **Extract features**: depending on the selected space:
   - **RGB**: uses the color values directly.
   - **HSV**: converts to HSV and extracts the three channels.
   - **RGBxy** and **HSVxy**: add normalized spatial coordinates as extra features.
3. **K-means manual**:
   - Initializes `k` random centroids.
   - Iterates by assigning each pixel to the nearest centroid and recalculating the centroids.
   - To avoid empty centroids, it keeps the previous centroid if no points are assigned.
   - Stop iterating if the centroid variation is less than `tol`.
4. **Reconstruction of the segmented image**: each pixel is assigned the color of its centroid and, for HSV spaces, it is converted back to RGB.
5. ** Visualization and saving**: a figure with subplots is created for each feature space and saved in `segment_<k>_all-png`.

## Generated outputs
For each value of `k` in `ks`, a PNG file named `segment_<k>_all.png` is created containing the segmentation in all feature space side by side.

## Examples
**Input image
![Input Image](https://imgur.com/a/aBCKnO4)


## Author
- [RogerGonzalezM](https://github.com/RogerGonzalezM/)
