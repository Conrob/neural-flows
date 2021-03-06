function [Ix, Iy, Iz, It] = flows3d_cnem_calculate_partial_derivatives(F1, F2, ht, B)
% This fuction computes 3D+t partial derivatives between two 3D image frames,
% and is meant to be used by the Horn-Schunck algotithm, except that it
% uses cnem.
%
% ARGUMENTS:
%       F1, F2      --  two subsequent 2D arrays 
%       ht          --  a double with the time step size 
%       B           --  CNEM differential matrix                 
% OUTPUT:eeee
%   Ix, Iy, Iz, It  --  partial derivatives along X, Y, Z and T axes respectively
%
% AUTHOR:
%     Paula Sanz-Leon, QIMR Berghofer, April 2020
% USAGE:
%{
    
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
   
    xdim = 1;
    ydim = 2;
    zdim = 3;
    % Spatial derivatives are computed as the average of 
    % the two image/frame gradients along each direction,
    % thus the magic number 0.5 in front of Ix, Iy, Iz
    Ix = (0.5*(get_derivative(F1, xdim, B) + get_derivative(F2, xdim, B)));
    Iy = (0.5*(get_derivative(F1, ydim, B) + get_derivative(F2, ydim, B)));
    Iz = (0.5*(get_derivative(F1, zdim, B) + get_derivative(F2, zdim, B)));
    It = [(F1 - F2)/ht].';

end % flows3d_cnem_calculate_partial_derivatives()

function I = get_derivative(F, dim, B)
    Ixyz = flows3d_cnem_grad_V(B, F.');
    I = Ixyz(:, dim);
end % function get_derivative()
