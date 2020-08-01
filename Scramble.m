% 
% function encrypted_image = Scramble (Index, original_image)
% 
%   This function performs global random permutation (GRP) encryption.
%   
%   Inputs
%   original_image: the original image which is required to be encrypted.
%   Index: random index for global random permutation

%   Outputs
%   encrypted_image: the encrypted image by using GRP encryption.

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


function encrypted_image = Scramble (Index, original_image)

[row, col] = size(original_image);

size_images = row;

 vec_reshape_image = reshape(original_image, size_images * size_images, 1);        %    图像列处理化
 
 enc_vec_reshape_image = zeros(size_images * size_images, 1);            %    加密后图像
 
 for i=1: 1: size_images * size_images
     
     enc_vec_reshape_image (i) =  vec_reshape_image(Index(i));
     
 end
 
 encrypted_image = reshape(enc_vec_reshape_image, size_images, size_images); 