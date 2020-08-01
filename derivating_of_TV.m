
% function derivative_of_TV = derivating_of_TV (image, size_images)

%  This function calculates the derivative matrix of the original image.

%   Inputs
%   image: the original image.
%   size_images: the size of the image.

%   Outputs
%   derivative_of_TV: the derivative matrix of the original image.

%  For more details, please refer to the following paper.
%  Bo Zhang, Di Xiao and Yong Xiang, "Robust coding of encrypted images via 2D
%  compressed sensing," IEEE Transctions on Multimedia,2020, accepted.
%  Originally written by Bo Zhang(email: zhangboswjtu@163.com), Army Engineering University. 

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

function derivative_of_TV = derivating_of_TV (image, size_images)


N = size_images;             

q = 10^-7;

original_image = image;

X = zeros(N+2,N+2);

for i = 1:1:N
    
    for j = 1:1:N
        
        X(i+1,j+1) = original_image(i, j);
        
    end
    
end

for j=1:1:N+2
    
    X(1, j) =   X(2, j) ;
    
    X(N+2, j) =   X(N+1, j) ;
    
end

for i=1:1:N+2
    
    X(i, 1) =   X(i, 2) ;
    
    X(i, N+2) =   X(i, N+1) ;
    
end

Y = zeros(N+2,N+2);     

for i=2:1:N+1
    
    for j=2:1:N+1
        
        Y(i, j) = (2*X(i, j)-X(i-1, j)-X(i, j-1))/(sqrt((X(i, j)-X(i-1, j))^2+(X(i, j)-X(i, j-1))^2)+q)+(X(i, j)-X(i+1, j))/(sqrt((X(i+1, j)-X(i, j))^2+(X(i+1, j)-X(i+1, j-1))^2)+q)+(X(i, j)-X(i, j+1))/(sqrt((X(i, j+1)-X(i, j))^2+(X(i, j+1)-X(i-1, j+1))^2)+q);
        
           end
    
end
    
Z = zeros(N,N); 

    for i = 1:1:N
    
    for j = 1:1:N
        
        Z(i,j) = Y (i+1, j+1);
        
    end
    
    end

    derivative_of_TV = Z;
    
    
    
    
    
    