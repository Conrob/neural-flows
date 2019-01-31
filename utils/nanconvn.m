function C = nanconvn(A, B, shape, varargin)
% NANCONVN Convolution in ND ignoring NaNs.
%   C = NANCONV(A, K) convolves A and K, correcting for any NaN values
%   in the input vector A. The result is the same size as A (as though you
%   called 'conv' or 'conv2' with the 'same' shape).
%
%   C = NANCONV(A, K, 'param1', 'param2', ...) specifies one or more of the following:
%     'edge'     - Apply edge correction to the output.
%     'noedge'   - Do not apply edge correction to the output (default).
%     'nanout'   - The result C should have NaNs in the same places as A.
%     'nonanout' - The result C should have ignored NaNs removed (default).
%                  Even with this option, C will have NaN values where the
%                  number of consecutive NaNs is too large to ignore.
%                  This option only matters if 'a' or 'k' is a row vector,
%                  and the other is a column vector. Otherwise, this
%                  option has no effect.
%
%   NANCONV works by running 'conv2' either two or three times. The first
%   time is run on the original input signals A and K, except all the
%   NaN values in A are replaced with zeros. The 'same' input argument is
%   used so the output is the same size as A. The second convolution is
%   done between a matrix the same size as A, except with zeros wherever
%   there is a NaN value in A, and ones everywhere else. The output from
%   the first convolution is normalized by the output from the second 
%   convolution. This corrects for missing (NaN) values in A, but it has
%   the side effect of correcting for edge effects due to the assumption of
%   zero padding during convolution. When the optional 'noedge' parameter
%   is included, the convolution is run a third time, this time on a matrix
%   of all ones the same size as A. The output from this third convolution
%   is used to restore the edge effects. The 'noedge' parameter is enabled
%   by default so that the output from 'nanconv' is identical to the output
%   from 'conv2' when the input argument A has no NaN values.
%
% Based on nanconv from: 
% AUTHOR: Benjamin Kraus (bkraus@bu.edu, ben@benkraus.com)
% Copyright (c) 2013, Benjamin Kraus
% $Id: nanconv.m 4861 2013-05-27 03:16:22Z bkraus $

    % Apply default options when necessary.
    if ~exist('edge_correction','var') 
        edge_correction = true; 
    end

    if ~exist('nanout','var')
        nanout = true; 
    end

    if ~exist('shape','var') 
        shape = 'same';
        
    elseif(~strcmp(shape,'same'))
        error([mfilename ':NotImplemented'],'Shape ''%s'' not implemented', shape);
    end

    % Get the size of 'A' for use later.
    array_shape = size(A);


    % Flat function for comparison.
    unos  = ones(array_shape);

    % Flat function with NaNs for comparison.
    onan  = ones(array_shape);

    % Find all the NaNs in the input.
    nan_idx = isnan(A);

    % Replace NaNs with zero, both in 'A' and 'onan'.
    A(nan_idx)    = 0;
    onan(nan_idx) = 0;

    % Check that the filter does not have NaNs.
    if(any(isnan(B)))
        error([mfilename ':NaNinFilter'],'Filter (B) contains NaN values.');
    end

    % Calculate what a 'flat' function looks like after convolution with B.
    if(any(nan_idx(:)) || edge_correction)
        flat = convn(onan, B, shape);
    else
        flat = unos;
    end

    % The line above will automatically include a correction for edge effects,
    % so remove that correction if the user does not want it.
    if(any(nan_idx(:)) && ~edge_correction)
        flat = flat./convn(unos, B, shape); 
    end

    % Do the actual convolution
    C = convn(A, B, shape)./flat;

    % If requested, replace output values with NaNs corresponding to input.
    if(nanout)
        C(nan_idx) = NaN; 
    end


end % function nanconvn()
