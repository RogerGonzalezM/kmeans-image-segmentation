% Name: Roger Gonzàlez Monleon

function kmeans_segmentation()
    % Read image
    imagePath = 'ImageKMeans.jpg';
    I = im2double(imread(imagePath));
    [H, W, ~] = size(I);

    % k values and feature spaces
    ks = [2, 4, 8, 16];
    featureSpaces = {'RGB', 'HSV', 'RGBxy', 'HSVxy'};
    
    % Create Output directory if it doesnt't exist
    if ~exist('Output', 'dir')
        mkdir('Output');
    end

    for i = 1:numel(ks)
        k = ks(i);
        
        % Create figure for the k value
        figure('Name', sprintf('k = %d', k), ...
               'Units','normalized','Position',[0.1 0.1 0.8 0.6]);
        sgtitle(sprintf('Segmentation with k = %d', k), 'FontSize', 14);
        
        for e = 1:numel(featureSpaces)
            featureSpace = featureSpaces{e};

            % Exctract feature matrix N x D
            X = extractFeatures(I, featureSpace);

            % kmeans function
            [labels, centers] = kmeans_manual(X, k, 500, 1e-5);

            % Reconstruct segmented image
            seg_all = reshape(centers(labels, :), H, W, []);
            seg_color = seg_all(:,:,1:3);
            
            % If color values > 1, normalize
            if max(seg_color(:)) > 1
                seg_color = seg_color / 255;
            end
            
            % If space is HSV, convert to RGB for display
            if startsWith(featureSpace, 'HSV')
                seg_color = hsv2rgb(seg_color);
            end

            % Show subplots
            subplot(1, numel(featureSpaces), e);
            imshow(seg_color);
            title(featureSpace, 'FontSize',12);
        end
        
        % Save figures
        figName = sprintf('Output/segment_%d_all.png', k);
        saveas(gcf, figName);
    end
end

function X = extractFeatures(I, featureSpace)
    [H, W, ~] = size(I);
    N = H*W;
    switch featureSpace
        case 'RGB'
            X = reshape(I, N, 3);
        case 'HSV'
            HSV = rgb2hsv(I);
            X = reshape(HSV, N, 3);
        case 'RGBxy'
            % Normalized x, y coordinates to [0, 255]
            [Xc, Yc] = meshgrid(0:W-1, 0:H-1);
            XY = [Xc(:), Yc(:)] * (255 / max(H-1, W-1));
            C = reshape(I, N, 3) * 255;
            X = [C, XY];
        case 'HSVxy'
            % Normalized x, y coordinates to [0, 1]
            HSV = rgb2hsv(I);
            [Xc, Yc] = meshgrid(0:W-1, 0:H-1);
            XY = [Xc(:), Yc(:)] / max(H-1, W-1);
            C = reshape(HSV, N, 3);
            X = [C, XY];
        otherwise
            error('Unknown space');
    end
end

function [labels, centroids] = kmeans_manual(X, k, max_iters, tol)
    [n, d] = size(X);
    rng(0);

    % Initialize centroids with k random points from X
    idx = randperm(n, k);
    centroids = X(idx, :);

    labels = zeros(n, 1);
    for iter = 1:max_iters
        % Assign each point to the nearest centroid
        D = pdist2(X, centroids, 'euclidean');
        [~, newLabels] = min(D, [], 2);

        % Calculate new centroids
        newCentroids = zeros(k, d);
        for j = 1:k
            pts = X(newLabels==j, :);
            if isempty(pts)
                % If no points assigned, keep the old centroids
                newCentroids(j, :) = centroids(j, :);
            else
                newCentroids(j, :) = mean(pts, 1);
            end
        end

        % Convergence check
        if norm(newCentroids - centroids, 'fro') < tol
            labels = newLabels;
            break;
        end

        % Update for next iteration
        centroids = newCentroids;
        labels = newLabels;
    end
end