im = rgb2gray(imread('lena.jpg'));
im = double(im);
[n_row,n_col] = size(im);
N = n_row;
k_iter = 300;
A = zeros(N,N);
d_t  = 0.05;
% Set up derivative operator
temp = zeros(N*N,2);
temp(:,1) = 1;
temp(:,2) = -1;
d_x = spdiags(temp,[0,1],N*N,N*N);
d_y = spdiags(temp,[0,N],N*N,N*N);
% Get gradient nabla.
[g_x,g_y] = gradient(im);
nabla = abs(g_x) + abs(g_y);
T = mean(nabla(:));

%Compute Gamma
gamma = 1 ./(1 + (abs(nabla)./T).^2);
gam = spdiags(reshape(gamma,[],1),0:0,N*N,N*N);
PM = - (d_x' * gam * d_x + d_y' * gam  *d_y);




for k=1:k_iter
    im = reshape(im,[],1);
    im = im + d_t * PM * im;
    im = reshape(im, N, N);
   
% Achive similar result but much slower.
%     temp = zeros(N*N,2);
% temp(:,1) = 1;
% temp(:,2) = -1;
% d_x = spdiags(temp,[0,1],N*N,N*N);
% d_y = spdiags(temp,[0,N],N*N,N*N);
% PM = - (d_x' * gam * d_x + d_y' * gam  *d_y);
%     
%         
    tl_quad = im(1:256,1:256);
    local_max = max(tl_quad(:));
    [x_max, y_max] = find(tl_quad == local_max);
    
    imshow(uint8(im));
    Header  = '2D Anisotropic diffusion';
    info = ['k = ', num2str(k), ' Local Maxima : [',num2str(x_max),',',num2str(y_max),']'];
    title({Header,info});
    hold on;
    
    plot(y_max, x_max, 'x','LineWidth', 2, 'MarkerEdgeColor', 'r');
    drawnow;
end

