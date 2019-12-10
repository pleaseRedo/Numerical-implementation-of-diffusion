im = rgb2gray(imread('lena.jpg'));
im = double(im);
% Line 256 of lena
f_0 = im(:,256);
[n_row,n_col] = size(im);
N = length(f_0);
A = zeros(N,N);


for k = 1:N
    for j = 1:N
        if k == j % The diagonal 
            if k == 1 % Top left case
               A(k,j) = -1;
               A(k,j+1) = 1;
            elseif k == N % Bottem right case
               A(k,j) = -1;
               A(k,j-1) = 1;
            else
                A(k,j) = -2;
                A(k,j+1) = 1;
                A(k,j-1) = 1;
            end                
        end  
    end   
end
f_explicit = f_0;
f_implicit = f_0;


k_iter = 100;
d_t = 0.5;
% subplot(1,3,1);
% plot(f_0); %show signal
% title({['Input signal ']});   

for k = 1:k_iter
        % explicit scheme
    f_explicit = exp_scheme(f_explicit,A,d_t);
    f_implicit = imp_scheme(f_implicit,A,d_t,N);

    subplot(1,3,1);
    plot(f_explicit);   
    axis([0, N min(f_0), max(f_0)])

    title({['explicit scheme '],['k_iteration = ',num2str(k), ' d_t= ',num2str(d_t)]});   

    subplot(1,3,2);
    plot(f_implicit);
    title({['implicit scheme '],['k_iteration= ',num2str(k), ' d_t= ',num2str(d_t)]});
    axis([0, N min(f_0), max(f_0)])

    drawnow;
end

% Gaussian
sigma = sqrt(2 * k_iter * d_t);
f_gaussian = f_0;
h = fspecial('gaussian',[100,100],sigma);
f_gaussian = imfilter(f_gaussian,h,'symmetric');
axis([0, N min(f_0), max(f_0)])

subplot(1,3,3), plot(f_gaussian);
title({['gaussian filter '],['k_iteration ',num2str(k_iter), ' d_t= ',num2str(d_t)]});
axis([0, N min(f_0), max(f_0)])

function [fk_next] = exp_scheme(fk,A,d_t)
    fk_next = fk + d_t * A * fk;
end


% function for implicit scheme
function [fk_next] = imp_scheme(fk, A,d_t,N)
    I  = eye(N);
    fk_next = (I - d_t * A) \ fk;
end