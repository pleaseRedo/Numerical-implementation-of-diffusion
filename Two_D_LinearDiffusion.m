im = rgb2gray(imread('lena.jpg'));
im = double(im);
N = size(im,1);

% Reshaping f to N^2 by 1
f_k = reshape(im,N*N,1);

dd = zeros(N*N,3);
dd(:,1) = 1;
dd(:,2) = -2;
dd(:,3) = 1;



% Decompose A into A_x and A_y

d_x = [-1,0,1];
d_y = [-N,0,N];
dim = N*N;
A_x = spdiags(dd, d_x,dim, dim);
A_y = spdiags(dd, d_y,dim, dim);

I = speye(dim);d_t = 0.5;
k_iter = 25;
for k = 1:k_iter
    % Folling the equation given by the cw specs
    IAx = (I - d_t/2 * A_x);
    fk_h = IAx \ ((I + d_t/2 * A_y)*f_k);
    
    IAy = (I - d_t/2 * A_y);
    f_k = IAy \ ((I + d_t/2 * A_x)*fk_h);

    img = reshape(f_k,N,N);
    
    % Local minima from the top left quadrant
    tl_quad = img(1:256,1:256);
    local_max = max(tl_quad(:));
    [x_max, y_max] = find(tl_quad == local_max);
    imshow(uint8(img));
    Header  = '2D linear diffusion ';
    info = ['k = ', num2str(k), ' Local Maxima : [',num2str(x_max),',',num2str(y_max),']'];
    title({Header,info});
    
    
    
    hold on,plot(y_max, x_max, 'x','LineWidth', 2, 'MarkerEdgeColor', 'r');
    drawnow;
end

