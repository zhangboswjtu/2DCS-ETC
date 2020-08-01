
% function reconstructed_image = 2DPG_ED (Y, Phi1, Phi2,  RBI_matrix, Index, 
% ...num_rows, num_cols, num_levels)

%  This function performs image reconstruciton by using 2D projected
%  gradient with embedding decryption (2DPG-ED) algorithm.

%   Inputs
%   Y: the 2DCS samples.
%   Phi1, Phi2: the measurement matrices.
%   RBI_matrix: : the random binary integer matrix which is used for NPT encryption.
%   Index: the random index for global random permutation.
%   num_rows: the number of rows.
%   num_cols: the number of columns.
%   num_levels: Wavelet decomposition level. 
%   Outputs
%   reconstructed_image: the reconstructed image by using 2DPG-ED algorithm.

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


function reconstructed_image = TDPG_ED (Y, Phi1, Phi2,  RBI_matrix, Index, num_rows, num_cols, num_levels)

addpath('C:\Users\zb\Desktop\TDCS-ETC\mywork');                      %    functions


lambda = 6;                            %  the convergence-control factor

max_iterations = 200;            %  maximum iteration number

TOL = 0.0001;                         %  the given error tolerance

D_prev = 0;                             

num_factor = 0;                     

 pinvPhi1 =  pinv (Phi1);
 
 pinvPhi2 = pinv (Phi2');

X = pinvPhi1 * Y * pinvPhi2;         %    Initialization

for i = 1:max_iterations
    
      
 [X, D] = SPLIterationBivariate (Y, X, Phi1, Phi2,   pinvPhi1, pinvPhi2, RBI_matrix, Index, num_rows, num_cols, lambda, num_levels);                   

 
 % if the difference between the current solution and the previous solution is smaller 
 % than the given error tolerance, break.
 
  if ((D_prev ~= 0) && (abs(D - D_prev) < TOL))     
      
          break;
          
  end
 
  D_prev = D;
  
end

end_level = 1;

[X D] = SPLIterationBivariate (Y, X, Phi1, Phi2,  pinvPhi1, pinvPhi2, RBI_matrix, Index, num_rows, num_cols, lambda, num_levels);


X = negative_postive_inverse_transform (X, RBI_matrix, num_rows);     

reconstructed_image = Unscramble (Index, X);             




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [X, D] = SPLIterationBivariate(Y, X, Phi1, Phi2, pinvPhi1, pinvPhi2, NPT_model, Index, num_rows, num_cols, lambda, num_levels)

[af, sf] = farras;

L = 12;

r = 0.8;                                     %   the step-size

X1 = X;                                     %    Save the previous solution

X = negative_postive_inverse_transform (X, NPT_model, num_rows);     

X_hat  = Unscramble (Index, X);

% Gradient descent in spatial domain

X_hat = X_hat - r * derivating_of_TV(X_hat, num_rows);     

% Bivariate shrinkage in wavelet domain
 
X_check = dwt2D(symextend(X_hat, L * 2^(num_levels - 1)), ...
    num_levels, af);                                                 
 
if (nargin == 9)                         
    
  end_level = 1;
  
else
    
  end_level = num_levels - 1;
  
end

X_check = SPLBivariateShrinkage(X_check, end_level, lambda);

X_bar = idwt2D(X_check, num_levels, sf);           

Irow = (L * 2^(num_levels - 1) + 1):(L * 2^(num_levels - 1) + num_rows);

Icol = (L * 2^(num_levels - 1) + 1):(L * 2^(num_levels - 1) + num_cols);

X_bar = X_bar(Irow, Icol);

% Projection onto the solution space in cipher domain

X_bar = Scramble (Index, X_bar);                                 

X_bar = negative_postive_transform (X_bar, NPT_model, num_rows);     

X = X_bar +  pinvPhi1 * (Y-Phi1 *X_bar * Phi2')* pinvPhi2;                
  
D = RMS(X, X1);
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function x_check = SPLBivariateShrinkage(x_check, end_level, lambda)

windowsize  = 3;
windowfilt = ones(1, windowsize)/windowsize;

tmp = x_check{1}{3};
Nsig = median(abs(tmp(:)))/0.6745;

for scale = 1:end_level
  for dir = 1:3
    Y_coefficient = x_check{scale}{dir};
    
    Y_parent = x_check{scale+1}{dir};
    
    Y_parent = expand(Y_parent);
    
    Wsig = conv2(windowfilt, windowfilt, (Y_coefficient).^2, 'same');
    Ssig = sqrt(max(Wsig-Nsig.^2, eps));
    
    T = sqrt(3)*Nsig^2./Ssig;
    
    x_check{scale}{dir} = bishrink(Y_coefficient, ...
	Y_parent, T*lambda);
  end
end
