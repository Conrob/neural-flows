function null_points_3d = flows3d_grid_detect_nullflows_velocities(mvel_obj, detection_threshold)
% This evaluates the singularity detection functions, and the effect of the 
% threshold currently used.
%
% ARGUMENTS:
%          mvel_obj -- a MatFile or structure with an unsteady flow 
%                         
% OUTPUT: 
%          null_points_3d -- a struture of length tpts, with the following
%                            fields:
%                                   xyz_idx -- linear indices, with respect
%                                              to the grid size of the detected
%                                              singularities. 
%                                   x, y, z -- a float with the best approximation of the
%                                              coordinates of the singularities. 
%                                              Values wiill depend on the
%                                              resolution of the grid.
%
% REQUIRES: 
%           
%          
% USAGE:
%{     

%}
%
% MODIFICATION HISTORY:
%     Paula Sanz-Leon -- QIMR February 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    % If MatFile
    tpts = size(mvel_obj, 'ux', 4); %#ok<GTARG>
catch
    % if struct
    tpts = size(mvel_obj.ux, 4);
end
    
null_points_3d = struct([]); 
X = mvel_obj.X;
Y = mvel_obj.Y;
Z = mvel_obj.Z;

    for tt=1:tpts
         null_points_3d(tt).xyz_idx = locate_null_velocity_coordinates(mvel_obj.un(:, :, :, tt), ...
                                                                       detection_threshold);      
                                                            
         null_points_3d(tt).x = locate_points(X, null_points_3d(tt).xyz_idx);
         null_points_3d(tt).y = locate_points(Y, null_points_3d(tt).xyz_idx);
         null_points_3d(tt).z = locate_points(Z, null_points_3d(tt).xyz_idx);
    end 
    
    

end

% Uses the vector fields to locate singularities
function xyz_idx = locate_null_velocity_coordinates(un, detection_threshold)
        
        % NOTE: need to come up with better ways to detect these points
        xyz_idx = find(un >= detection_threshold(1) & un < detection_threshold(2));

end

function p = locate_points(XX, idx)
    p = XX(idx);
end


