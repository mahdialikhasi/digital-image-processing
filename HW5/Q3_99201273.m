function main
    % read image
    image = imread("airplane2.png");
    image = rgb2gray(image);
    
    % make it binary
    binary_image = (image > 128);
    
    % part a
    % create feature vector
    features = extract_features(binary_image);
    
    % Part b
    % compute pca
    % compute mean
    avg = mean(features);
    x_p = double(features) - avg;
    
    % compute covariance
    c_x = (x_p' * x_p);
    
    % part c
    % compute eigen value and eigen vectors
    [U,S,V] = svd(c_x);
    y = x_p * U;
    e1 = U(:,1);
    e2 = U(:,2);
    
    % Plot
    figure;
    subplot(221);
    imshow(binary_image, []);
    title("Binary image");
    subplot(222);
    hold on;
    imshow(binary_image, []);
    plot(avg(1),avg(2),'r*');
    line([avg(1), avg(1) + e1(1) * 250],[avg(2) avg(2) + e1(2) * 250], 'Color', 'w');
    line([avg(1), avg(1) + e2(1) * 150],[avg(2) avg(2) + e2(2) * 150], 'Color', 'blue');
    title("Object with eignvectors of its covarince matrix");
    subplot(223);
    show_image_from_points(y);
    title("Translate object to PCA space");
    t = y - min(y) + 1;
    subplot(224);
    show_image_from_points(t);
    title("Translate object so all coordinate are non negative");
end

function output = extract_features(image)
    % Description : Extract feature vector of image.
    % Inputs :
    %       image : the bonary image
    % Outputs :
    %       output : features vector. each (x, y) coordinate in image is a
    %       feature in features vector.
    
    output = zeros(size(image, 1) * size(image, 2) - sum(sum(image)), 2, 'int16');
    counter = 1;
    for i=1:size(image, 1)
        for j=1:size(image, 2)
            if(image(i,j) == 0)
                output(counter, :) = [j,i];
                counter = counter + 1;
            end
        end
    end
end

function output = create_image_from_points(points)
    % Description : given a set of points, create a image from that
    % Inputs :
    %           points : points which should be 1
    % Output :
    %           output : constructed image
    
    normalized = points - min(points) + 1;
    output = ones(ceil(max(normalized(:,2))), ceil(max(normalized(:,1))), 'uint8');
    for i=1:size(normalized, 1)
        output(ceil(normalized(i,2)), ceil(normalized(i,1))) = 0;
    end
end

function show_image_from_points(y)
    % Description : Show an object base on its points
    % Inputs :
    %           y : object's point
    
    axis([min(y(:,1)) max(y(:,1)) min(y(:,2)) max(y(:,2))]);
    plot(y(:,1),y(:,2),'black*');
end