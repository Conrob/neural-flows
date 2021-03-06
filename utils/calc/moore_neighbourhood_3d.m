function [Mx, My, Mz] = moore_neighbourhood_3d(ii, jj, kk)
% Returns 3 matrices of size 3x3x3, each of which has the subscripts along
% each dimensions of the neighbours of a point ii, jj, kk in a 3D Moore neighbourhood. 
%
% ARGUMENTS:
%        ii -- subscript of the centre point along the +1st+ spatial
%              dimension (y)
%        jj -- subscript of the centre point along the +2nd+ spatial
%              dimension (x)
%        kk -- subscript of the centre point along the +3rd+ spatial
%              dimension (z)
%
% OUTPUT: 
%        Mx -- 3 x 3 x 3 array with the subscripts along the +first+ dimension 
%              of the 26 nearest neighbours 
%        My -- 3 x 3 x 3 array with the subscripts along the +second+ dimension 
%              of the 26 nearest neighbours 
%        Mz -- 3 x 3 x 3 array with the subscripts along the +third+ dimension 
%              of the 26 nearest neighbours 

% REQUIRES: 
%        None
%
% USAGE:
%{
    [Mx, My, Mz] = moore_neighbourhood_3d(21, 42, 84)
%}
%
% AUTHOR: 
%       Paula Sanz-Leon, QIMR Berghofer, 2019-02
% 
% TODO: warn for negative subscripts, if this was written in python that 
%       wouldn't be a problem. The user may want to use negative subscripts
%       for handling boundary conditions

% In the 3x3x3 cube, this is the subscript of the central point along the 
% third dimension.
k_centre = 2;

           Mx(:, :, k_centre-1) = [ jj-1  jj   jj+1;
                                    jj-1  jj   jj+1;
                                    jj-1  jj   jj+1];
                       
           Mx(:, :, k_centre)  =  [ jj-1  jj   jj+1;
                                    jj-1  jj   jj+1;
                                    jj-1  jj   jj+1];
                       
           Mx(:, :, k_centre+1) = [ jj-1  jj   jj+1;
                                    jj-1  jj   jj+1;
                                    jj-1  jj   jj+1];
                       
                       
                       
           My(:, :, k_centre-1) =  [ ii-1  ii-1   ii-1;
                                     ii    ii     ii;
                                     ii+1  ii+1   ii+1];
                        
           My(:, :, k_centre)   =  [ ii-1  ii-1   ii-1;
                                     ii    ii     ii;
                                     ii+1  ii+1   ii+1];
                        
           My(:, :, k_centre+1) =  [ ii-1  ii-1   ii-1;
                                     ii    ii     ii;
                                     ii+1  ii+1   ii+1];
        
                                 
                        
           Mz(:, :, k_centre-1) =  [ kk-1  kk-1   kk-1;
                                     kk-1  kk-1   kk-1;
                                     kk-1  kk-1   kk-1];
                        
                                   
           Mz(:, :, k_centre)   =  [ kk    kk     kk;
                                     kk    kk     kk;
                                     kk    kk     kk];
                        
           Mz(:, :, k_centre+1) =  [ kk+1  kk+1   kk+1;
                                     kk+1  kk+1   kk+1;
                                     kk+1  kk+1   kk+1];
end   % function moore_neighbourhood_3d()
