% 
% 2DCS-ETC scheme: 2D Compressed Sensing based Encryption-Then-Compression.
% This code runs the experiments for 2DCS-ETC scheme.

%  Bo Zhang, Di Xiao and Yong Xiang, "Robust coding of encrypted images via 2D
%  compressed sensing," IEEE Transctions on Multimedia,2020, accepted.
%
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

clc;

clear;

addpath('C:\Users\zb\Desktop\TDCS-ETC\dataset11');                   %    The test images

addpath('C:\Users\zb\Desktop\TDCS-ETC\WaveletSoftware');       %     WaveletSoftware

addpath('C:\Users\zb\Desktop\TDCS-ETC\mywork');                      %    functions

%%  ！ ！ ！ ！ ！  ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！

%  test images from dataset11

% filename = 'lena';                               

% filename = 'barbara';                     

% filename = 'boats';                        

% filename = 'cameraman';              

% filename = 'foreman';                      

% filename = 'house';                       

% filename = 'Monarch';                     

filename = 'Parrots';        

original_filename = [ filename '.tif'];                                   

original_image = double(imread(original_filename));         

[num_rows, num_cols] = size(original_image);    

%  ！ ！ ！ ！ ！  ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！

%  Parameters

subrate = 0.5;                                         %   subrate

quantizer_bitdepth = 6;                         %    quantizer_bitdepth

size_images = 256;                                %    the number of rows (or columns) of the image ( square matrix only! )

num_levels = 3;                                     %    Wavelet decomposition level          


%%  image encryption

%  global random permutation (GRP) operation

 Index = randperm (size_images * size_images);                                       %    generate a random index for GRP operation
 
 intermediate_encrypted_image = Scramble (Index, original_image);
 
 %  ！ ！ ！ ！ ！  ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！
 
%  negative-positive transformation (NPT) operation

 RBI_matrix = zeros (size_images, size_images);  %  generate a random binary integer matrix for  NPT operation
 
for i = 1: size_images
    
    for j = 1: size_images
        
        Permutation = randperm ( 2 )  ; 
        
        if Permutation (1) ==1
            
          RBI_matrix  (i, j) = 0;
           
        else
            
          RBI_matrix  (i, j) = 1;
          
        end
        
    end
    
end

% NPT encryption

final_encrypted_image = negative_postive_transform (intermediate_encrypted_image, RBI_matrix, size_images);
   

%% Encrypted-image compression
 
 %  Gray mapping operation
 
  template_matrix = zeros (size_images, size_images);     %   generate a template matrix

for i=1:1:size_images
    
    for j =1:1:size_images
        
    template_matrix (i, j)  = 128;

    end
    
end

final_encrypted_image_GM = final_encrypted_image - template_matrix;    

%  ！ ！ ！ ！ ！  ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！ ！
    
%   2D compressed sensing (2DCS)

%  generate two random measurement matrices

M = round(sqrt(subrate * size_images* size_images));       

Phi1 = orth(randn(size_images, size_images))';                   

Phi1 = Phi1(1:M, :);
 
Phi2 = orth(randn(size_images, size_images))';                   

Phi2 = Phi2(1:M, :);

tic;

Y =  Phi1 * final_encrypted_image_GM * Phi2';                 %   2DCS projection

time_encoder = toc;

%  Scalar quantization

[yq, rate_sq] = SQ_Coding (Y, quantizer_bitdepth, num_rows, num_cols);    


%%  Image reconstruction

% Locally recover the 2DCS samples of the final_encrypted_image

Y_template_matrix =  Phi1 *  template_matrix * Phi2';      %   Recover the 2DCS samples of the template matrix at the decoder side                       

Yq =yq + Y_template_matrix;                                             %   Recover the 2DCS samples

% Image reconstruciton by using 2D projected gradient with embedding decryption (2DPG-ED) algorithm.

tic;

reconstructed_image = TDPG_ED (Yq, Phi1, Phi2, ...
    RBI_matrix, Index, num_rows, num_cols, num_levels);

time_decoder = toc;

PSNR = psnr(uint8(reconstructed_image), uint8(original_image));                    

   figure(1);
   
   imshow(uint8(original_image),'Border','tight');
   
   figure(2);
   
   imshow(uint8(final_encrypted_image),'Border','tight'); 
   
   figure(3);
   
   imshow(uint8(reconstructed_image),'Border','tight');
   









