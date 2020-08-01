
% 
% function dencrypted_image_NPT = negative_postive_inverse_transform (encrypted_image, RBI_matrix, size_images)
% 
%   This function performs NPT decryption.
%   
%   Inputs
%   encrypted_image: the encrypted_image which is required to be decrypted.
%   RBI_matrix: random binary integer matrix.
%   size_images: the size of the image.
%   Outputs
%   decrypted_image_NPT: the decrypted image. 

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

function  decrypted_image_NPT = negative_postive_inverse_transform (encrypted_image, RBI_matrix, size_images)

decrypted_image_NPT = encrypted_image;                              

for i = 1: size_images
    
    for j = 1: size_images
        
        
        if RBI_matrix (i, j) ==1
            
          decrypted_image_NPT  (i, j) =   256- decrypted_image_NPT  (i, j);
           
        else
            
         decrypted_image_NPT (i, j) =   decrypted_image_NPT  (i, j);
          
        end
        
    end
    
end


