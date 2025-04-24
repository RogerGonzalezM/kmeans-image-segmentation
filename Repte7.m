% Nombre: Roger Gonzàlez Monleon

function kmeans_segmentation()
    % Llegir imatge
    rutaImatge = 'ImatgeKMeans.jpg';
    I = im2double(imread(rutaImatge));
    [H, W, ~] = size(I);

    % Valors de k i espais de característiques
    ks = [2, 4, 8, 16];
    espais = {'RGB', 'HSV', 'RGBxy', 'HSVxy'};

    for i = 1:numel(ks)
        k = ks(i);
        
        % Creació de figura pel valor de k
        figure('Name', sprintf('k = %d', k), ...
               'Units','normalized','Position',[0.1 0.1 0.8 0.6]);
        sgtitle(sprintf('Segmentació amb k = %d', k), 'FontSize', 14);
        
        for e = 1:numel(espais)
            espai = espais{e};
            % Extraure matriu de característiques N x D
            X = extractFeatures(I, espai);

            % Funció de kmeans
            [labels, centers] = kmeans_manual(X, k, 500, 1e-5);

            % Reconstruim imatge segmentada
            seg_all = reshape(centers(labels, :), H, W, []);
            seg_color = seg_all(:,:,1:3);
            
            % Si els valors de color > 1, normalitzem
            if max(seg_color(:)) > 1
                seg_color = seg_color / 255;
            end
            
            % Si l'espai es HSV, convertim a RGB per visualitzar
            if startsWith(espai, 'HSV')
                seg_color = hsv2rgb(seg_color);
            end

            % Mostrar subplots
            subplot(1, numel(espais), e);
            imshow(seg_color);
            title(espai, 'FontSize',12);
        end
        
        % Guardar figures
        nomFig = sprintf('segment_%d_tots.png', k);
        saveas(gcf, nomFig);
    end
end

function X = extractFeatures(I, espai)
    [H, W, ~] = size(I);
    N = H*W;
    switch espai
        case 'RGB'
            X = reshape(I, N, 3);
        case 'HSV'
            HSV = rgb2hsv(I);
            X = reshape(HSV, N, 3);
        case 'RGBxy'
            % Coordenades x, y normalitzades a [0, 255]
            [Xc, Yc] = meshgrid(0:W-1, 0:H-1);
            XY = [Xc(:), Yc(:)] * (255 / max(H-1, W-1));
            C = reshape(I, N, 3) * 255;
            X = [C, XY];
        case 'HSVxy'
            % Coordenades x, y normalitzades a [0,1]
            HSV = rgb2hsv(I);
            [Xc, Yc] = meshgrid(0:W-1, 0:H-1);
            XY = [Xc(:), Yc(:)] / max(H-1, W-1);
            C = reshape(HSV, N, 3);
            X = [C, XY];
        otherwise
            error('Espai no conegut');
    end
end

function [labels, centroids] = kmeans_manual(X, k, max_iters, tol)
    [n, d] = size(X);
    rng(0);

    % Inicialitzar centroides amb k punts aleatoris d'x
    idx = randperm(n, k);
    centroids = X(idx, :);

    labels = zeros(n, 1);
    for iter = 1:max_iters
        % Assignació de cada punt al centroide
        D = pdist2(X, centroids, 'euclidean');
        [~, newLabels] = min(D, [], 2);

        % Calcular nous centroides
        newCentroids = zeros(k, d);
        for j = 1:k
            pts = X(newLabels==j, :);
            if isempty(pts)
                % Si no assignem punts, mantenir els centroides d'abans
                newCentroids(j, :) = centroids(j, :);
            else
                newCentroids(j, :) = mean(pts, 1);
            end
        end

        % Comprovació de convergencia
        if norm(newCentroids - centroids, 'fro') < tol
            labels = newLabels;
            break;
        end

        % Actualitzar per la següent iteració
        centroids = newCentroids;
        labels = newLabels;
    end
end