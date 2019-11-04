function  [singularity_classification_list] =  singularity3d_classify_singularities_parallel(null_points_3d, mvel_obj)
% 1) calculates jacobian for each critical point, and then 
% 2) classify type of critical point. 
% ARGUMENTS:
%          null_points_3d        -- a struct of size [1 x no. timepoints]
%                                -- .xyz_idx [no. of singularities x 1] -- linear indices 
%                                            [no. of singularities x 3] -- subscripts
%          mvel_obj              -- a MatFile handle pointing to the flows/velocity
%                            fields. Needed for the calculation of the
%                            jacobian matrix. Or a matlab structure with
%                            the same fields as the matfile produced by the
%                            code.
% OUTPUT:
%         singularity_classification  --  a cell array of size [1 x no. timepoints]
%                                         where each element is a cell of size
%                                         [no. of singularities]. The cells
%                                         have human readable strings with
%                                         the type of singularity detected. 
% REQUIRES:
%          switch_index_mode()
%          singularity3d_classify_singularities_step()
%          
% AUTHOR:
%     Paula Sanz-Leon, QIMR Berghofer February 2019
% USAGE:
%{
    
%}
% NOTE: as the timeseries get longer, we can in principle parallelise this
% function.
singularity_classification_list = cell(size(null_points_3d));
tpts = size(null_points_3d, 2);

% Load options structure
options   = mvel_obj.options;
grid_size = options.flow_calculation.grid_size;

% Check if we stored linear indices or subscripts 
if size(null_points_3d(1).xyz_idx, 2) < 2
    for tt=1:tpts
        xyz_subs = switch_index_mode(null_points_3d(tt).xyz_idx, 'subscript', grid_size);
        null_points_3d(tt).xyz_idx = xyz_subs;
    end    
    
end

hx = mvel_obj.hx; 
hy = mvel_obj.hy; 
hz = mvel_obj.hz; 

null_points_cell = struct2cell(null_points_3d);
null_points_cell = squeeze(null_points_cell(1, 1, :));

parfor tt=1:tpts 

       % Check if we have critical points. There are 'frames' for which
       % nothing was detected, we should not attempt to calculate jacobian.

       null_points_3d_xyz_idx = null_points_cell{tt};
       % Create temp variables with partial load of a matfile. 
       ux = mvel_obj.ux(:, :, :, tt);
       uy = mvel_obj.uy(:, :, :, tt);
       uz = mvel_obj.uz(:, :, :, tt);

       singularity_labels = singularity3d_classify_singularities_step(null_points_3d_xyz_idx, ux, uy, uz, hx, hy, hz)
       singularity_classification_list{tt} = singularity_labels;

end

end % singularity3d_classify_singularities_parallel()
