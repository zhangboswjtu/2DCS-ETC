% 
% function decrypted_image = Unscramble (Index, encrypted_image)
% 
%   This function performs global random permutation (GRP) decryption.
%   
%   Inputs
%   encrypted_image: the encrypted image by using GRP encryption.
%  Index: random index for global random permutation

%   Outputs
%   decrypted_image: the decrypted_image.

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

function decrypted_image = Unscramble (Index, encrypted_image)

[row, col] = size(encrypted_image);

size_images = row;

 vec_reshape_encrypted_image = reshape(encrypted_image, size_images * size_images, 1);       
 
 vec_reshape_image = zeros(size_images * size_images, 1);            
 
 for i=1: 1: size_images * size_images
     
     vec_reshape_image (Index(i)) =  vec_reshape_encrypted_image(i);
     
 end
 
decrypted_image = reshape(vec_reshape_image, size_images, size_images); 