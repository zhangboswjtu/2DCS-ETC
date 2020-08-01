
% 
% function dencrypted_image_NPT = negative_postive_inverse_transform (original_image, RBI_matrix, size_images)
% 
%   This function performs NPT encryption.
%   
%   Inputs
%   original_image: the original image which is required to be encrypted.
%   RBI_matrix: random binary integer matrix 
%   size_images: the size of the image
%   Outputs
%   encrypted_image_NPT: the encrypted image by using NPT  encryption.

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

function encrypted_image_NPT = negative_postive_transform (original_image, RBI_matrix, size_images)


for i = 1: size_images
    
    for j = 1: size_images
        
        
        if RBI_matrix  (i, j) ==1
            
          encrypted_image_NPT  (i, j) =   256-original_image (i, j);
           
        else
            
          encrypted_image_NPT  (i, j) =   original_image (i, j);
          
        end
        
    end
    
end



