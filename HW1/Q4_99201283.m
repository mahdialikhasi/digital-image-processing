function main
  img = imread('scenery.jpg');
  dim = size(img);
  grayscale = rgb2gray(img);
  
  figure;
  imshow(grayscale);
  title("Referenced image");
  
  figure;
  shearimg = shear(grayscale, 0.5, 0.25);
  imshow(shearimg);
  title("Sheared image");
  
  sheared_points = [
                    419, 329;
                    1788, 991;
                    1536,1047;
                    226,398;
                    ];
                    
  ref_points = [
                383, 137;
                1759,112;
                1457,319;
                145,326;
                ];
  
  co_efficients = find_transformation(ref_points,sheared_points);
  
  figure;
  rev = imresize(
          imcrop(
            co_eff_transform(shearimg, co_efficients),
            [552, 1241, 2483 - 552, 2316 - 1241]
          ), 
          [dim(1), dim(2)]
        );
  
  imshow(rev);
  title("Reverse transform");
  
  
  figure;
  imshow(grayscale - rev);
  title("difference between registered image and reverse transform");
end

function output=co_eff_transform(img, co_efficients)
  % apply custom transform on image
  % Inputs:
  %   img : input image
  %   co_efficients : the c1~c8 transform coefficients
  % Output :
  %   output : transformed image
  r = @(x)  x(:,1).* co_efficients(1) + x(:,2).* co_efficients(2) + x(:,2).* x(:,1).* co_efficients(3) + co_efficients(4);  
  w = @(x)  x(:,1).* co_efficients(5) + x(:,2).* co_efficients(6) + x(:,2).* x(:,1).* co_efficients(7) + co_efficients(8); 
  f = @(x, unused) [r(x), w(x)];

  tform2 = maketform('custom', 2, 2, [], f, []);
  output = imtransform(img, tform2);  
end

function output = shear(img, shx, shy)
  % apply shear transform on an input image
  % Input :
  %   img : input image
  %   shx : shear scale on x axis
  %   shy : shear scale on y axis
  % Outpus:
  %   output : image after being sheared
  
  affine_matrix = [1,shx,0;shy,1,0;0,0,1];
  output = imtransform(img, maketform('affine', affine_matrix));

end

function co_efficients = find_transformation(reference_points, transform_points)
  % Using least square error formula to calc co_efficients
  % Inputs :
  %   reference_points : a matrix of 4X2, representing four point in reference image
  %   transform_points : a matrix of 4X2, representing corresponding points in transformed image
  % Outputs :
  %   co_efficients : c1 ~ c8 in formula below
  %   x = c1.v + c2.w + c3.v.w + c4
  %   y = c5.v + c6.w + c7.v.w + c8
  b = [
      transform_points(1,1); 
      transform_points(2,1);
      transform_points(3,1);
      transform_points(4,1);
      ];
  a = [
      reference_points(1,1), reference_points(1,2), reference_points(1, 1) * reference_points(1, 2), 1;
      reference_points(2,1), reference_points(2,2), reference_points(2, 1) * reference_points(2, 2), 1;
      reference_points(3,1), reference_points(3,2), reference_points(3, 1) * reference_points(3, 2), 1;
      reference_points(4,1), reference_points(4,2), reference_points(4, 1) * reference_points(4, 2), 1;
      ];
  % co_efficients_part1 = lsqr(a, b);
  co_efficients_part1 = ols(b, a);
  b = [
      transform_points(1,2); 
      transform_points(2,2);
      transform_points(3,2);
      transform_points(4,2);
      ];
  % co_efficients_part2 = lsqr(a, b);
  co_efficients_part2 = ols(b, a);
  co_efficients = [co_efficients_part1; co_efficients_part2];
end
