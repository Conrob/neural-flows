function [fig_sing3d, ux, uy, uz] = generate_singularity3d_hyperbolic_critical_points(cp_type)
% Generate canonical hyperbolic critical points in a grid of side 2 in the
% range of [-1 1];
%
% ARGUMENTS:
%        cp_type -- a string specifying the type of hyperbolic critical
%        point.
%       
%
% OUTPUT: 
%        fig_sing3d -- Figure handle
%        ux -- 3D array with the x component of the vector field
%        uy -- 3D array with the x component of the vector field
%        uz -- 3D array with the x component of the vector field
%
% REQUIRES: 
%       s3d_get_singularity_list()
%       singularity3d_get_numlabel()
% USAGE:
%{
    
%}
% AUTHOR: Paula Sanz-Leon, QIMR September 2019 

x = -1:2^-4:1;
y = -1:2^-4:1;
z = -1:2^-4:1;

[X, Y, Z] = meshgrid(x, y, z);

switch cp_type
    case {'source'}
        ux = X;
        uy = Y;
        uz = Z;
        
        p1 = [0.01 0.01  0.1];
        p2 = [0.01 0.01 -0.1];
                
    case {'sink'}
        ux = -X;
        uy = -Y;
        uz = -Z;
        
        p1 = [ 0.5  0.5  0.5];
        p2 = [-0.5 -0.5 -0.5];
            
    case {'1-2-saddle'}
        % 1-out-2-in
        TH = atan2(Y, X);
        R = sqrt(X.^2+Y.^2);
        ux = -R.* cos(TH);
        uy = -R.* sin(TH);
        uz = Z;
        
        p1 = [  0.5  0.8  0.1];
        p2 = [ -0.5  -0.8 -0.1];
        
    case {'2-1-saddle'}
        TH = atan2(Y, X);
        R = sqrt(X.^2+Y.^2);
        ux = R.* cos(TH);
        uy = R.* sin(TH);
        uz = -Z;
        
        p1 = [ 0.1   0.1  1];
        p2 = [ 0.1  -0.1 -1];
           
    case {'spiral-sink'}
        ux =  Y-X;
        uy = -X-Y;
        uz = -2*Z;
        
        p1 = [-0.5, -0.5,  0.9];
        p2 = [-0.5,  0.8, -0.9];
        
    case {'spiral-source'}
        
        %NOTE: I'm not sure this critical point is entirely correct, as it 
        % basically becomes a limit cycle - centre 
        
        [ux, uy, uz] = spiral_source();
        uz = 3.5.*uz;
        % Seed xyz points for sample trajectory
        p1 = [0.0, -0.01, -0.01];
        p2 = [0.0,  0.01, +0.01];
 
    case {'1-2-spiral-saddle'}
        % 1-out-2-in
        [ux, uy, uz] = spiral_source();
        ux = -ux;
        uy = -uy;
 
        p1 = [ 0.5, -0.5,  0.05];
        p2 = [-0.5, -0.5, -0.05];
        
    case {'2-1-spiral-saddle'}
        % Source Spiral saddle - 2-out 1-in 
        [ux, uy, uz] = spiral_source();
        uz = -uz;
        
        p1 = [0.01, 0.01,  0.5];
        p2 = [0.01, 0.01, -0.5];
    case 'all'
        singularity_list = s3d_get_singularity_list();
        for kk=1:8
            generate_singularity3d_hyperbolic_critical_points(singularity_list{kk});
        end
        return
    otherwise
        error(['neural-flows::' mfilename '::UnknownType'], 'Unknown type of critical points')

end
% Get appropriate color
[~, color] = singularity3d_get_numlabel(cp_type);

fig_name = ['nflows-singularity3d_hyperbolic-cp-' cp_type];
fig_sing3d = figure('Name', fig_name);
fig_sing3d.Position = [1   18   19   17];
fig_sing3d.Color = [1, 1, 1];
ax(1) = subplot(2, 2, 4, 'Parent', fig_sing3d);
ax(2) = subplot(2, 2, 3, 'Parent', fig_sing3d);
ax(3) = subplot(2, 2, 2, 'Parent', fig_sing3d);
ax(4) = subplot(2, 2, 1, 'Parent', fig_sing3d);

hold(ax(1), 'on')
dsf = 2; % downsample factor
unorm = sqrt(ux.^2+uy.^2+uz.^2);
max_unorm = max(unorm(:));
quiv_handle = quiver3(X(1:dsf:end, 1:dsf:end, 1:dsf:end), ...
                      Y(1:dsf:end, 1:dsf:end,1:dsf:end), ...
                      Z(1:dsf:end, 1:dsf:end, 1:dsf:end), ...
                      ux(1:dsf:end,1:dsf:end,1:dsf:end)./max_unorm, ...
                      uy(1:dsf:end,1:dsf:end,1:dsf:end)./max_unorm, ...
                      uz(1:dsf:end,1:dsf:end,1:dsf:end)./max_unorm, 1);
                  
quiv_handle.Color = [0.2 0.2 0.2];
quiv_handle.LineWidth = 0.01;
quiv_handle.Parent = ax(1);

% Plot axes going through the centre
plot3(ax(1), [-1 1], [0 0], [0 0], 'color', [0.65 0.0 0.0], 'linewidth', 1.5)
plot3(ax(1), [0 0], [-1 1], [0 0], 'color', [0.0 0.65 0.0], 'linewidth', 1.5)
plot3(ax(1), [0 0], [0 0], [-1 1], 'color', [0.0 0.0 0.65], 'linewidth', 1.5)

% Plot the critical point at the origin
plot3(ax(1), 0, 0, 0, 'o', 'markerfacecolor', color(1:3), 'markersize', 12, 'markeredgecolor', color(1:3))

for ii=1:4
    ax(ii).XLim = [-1 1];
    ax(ii).YLim = [-1 1];
    ax(ii).ZLim = [-1 1];
end
ax(1).XLabel.String = 'x [mm]';
ax(1).YLabel.String = 'y [mm]';
ax(1).ZLabel.String = 'z [mm]';

% Spiral source
h1 = streamline(X, Y, Z, ux, uy, uz, p1(1), p1(2), p1(3));
h2 = streamline(X, Y, Z, ux, uy, uz, p1(1), p2(2), p2(3));

set(h1,'Color',[0.3 0.3 0.3]);
set(h2,'Color',[0.3 0.3 0.3]);
h1.Parent = ax(1);
h2.Parent = ax(1);

% Start points
plot3(ax(1), h2.XData(1), h2.YData(1), h2.ZData(1), 'x', 'markerfacecolor', 'r', 'markeredgecolor', 'r', 'markersize', 6)
plot3(ax(1), h1.XData(1), h1.YData(1), h1.ZData(1), 'x', 'markerfacecolor', 'r', 'markeredgecolor', 'r', 'markersize', 6)

% End points
plot3(ax(1), h1.XData(end), h1.YData(end), h1.ZData(end), 'ko', 'markerfacecolor', 'k', 'markeredgecolor', 'w')
plot3(ax(1), h2.XData(end), h2.YData(end), h2.ZData(end), 'ko', 'markerfacecolor', 'k', 'markeredgecolor', 'w')

view(3);

% Copy graphical objects onto other subplots 
copyobj(get(ax(1),'Children'),ax(2));
copyobj(get(ax(1),'Children'),ax(3));
copyobj(get(ax(1),'Children'),ax(4));

% Other refinements
% ZY - plane
ax(1).XLabel.String = 'x';
ax(1).YLabel.String = 'y';
ax(1).ZLabel.String = 'z';
ax(1).View = [90 0];
ax(1).Title.String = 'ZY';

id_x = ceil(length(x)/(2*dsf)); % index of the slice laong x-we need to keep.
U = ax(1).Children(end).UData;
V = ax(1).Children(end).VData;
W = ax(1).Children(end).WData;
ax(1).Children(end).UData = zeros(size(V));
ax(1).Children(end).VData = zeros(size(V));
ax(1).Children(end).WData = zeros(size(V));

ax(1).Children(end).UData(:, id_x, :) = U(:, id_x, :);
ax(1).Children(end).VData(:, id_x, :) = V(:, id_x, :);
ax(1).Children(end).WData(:, id_x, :) = W(:, id_x, :);


% ZX - plane
ax(2).YLabel.String = 'y';
ax(2).XLabel.String = 'x';
ax(2).ZLabel.String = 'z';
ax(2).View = [0 0];
ax(2).Title.String = 'ZX';

id_y = ceil(length(y)/(2*dsf)); % index of the slice laong x-we need to keep.
U = ax(2).Children(end).UData;
V = ax(2).Children(end).VData;
W = ax(2).Children(end).WData;
ax(2).Children(end).UData = zeros(size(V));
ax(2).Children(end).VData = zeros(size(V));
ax(2).Children(end).WData = zeros(size(V));

ax(2).Children(end).UData(id_y, :, :) = U(id_y, :, :);
ax(2).Children(end).VData(id_y, :, :) = V(id_y, :, :);
ax(2).Children(end).WData(id_y, :, :) = W(id_y, :, :);

% XY - plane
ax(3).YLabel.String = 'y';
ax(3).XLabel.String = 'x';
ax(3).ZLabel.String = 'z';
ax(3).View = [0 90];
ax(3).Title.String = 'XY';


% 3D view
ax(4).YLabel.String = 'y';
ax(4).XLabel.String = 'x';
ax(4).ZLabel.String = 'z';
ax(4).View = [40 17];
ax(4).GridAlpha = 0;
ax(4).Children(end).LineStyle = 'none';


% Correct the 2D projections so they look prettier -- in particular the
% spiral saddles and sources/sinks --



function [ux, uy, uz] = spiral_source()
        a = 0.2;
        b = 0.5;
        ux =  a*Y-(a.*abs(z)).*X;
        uy = -a*X-(a.*abs(z)).*Y;
        uz = -((b*Z)); %zeros(size(Z));
        uz(isnan(uz)) = 0;
        
        ux = -ux;
        uy = -uy;
        UV = sqrt(ux.^2 + uy.^2);
        ux = ux./UV; % This normalisation is basically for visaulisation purposes
        uy = uy./UV;
        ux(isnan(ux)) = 0; 
        uy(isnan(uy)) = 0;
        uz = -uz;
end
end
