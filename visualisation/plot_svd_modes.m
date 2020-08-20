function fig_spatial_modes = plot_svd_modes(V, U, X, Y, Z, prct_var, num_modes, time_vec)
    % V struct with components of spatial svd modes
    % U array temporal svd modes
    
    % Graphics elements
    fig_spatial_modes = figure('Name', 'nflows-spatial-modes');
    num_planes = 3; % number of spatial projections
    ax = gobjects(num_planes+1, num_modes);
    
    for ii=1:num_planes
        for kk=1:num_modes
            ax(ii, kk) = subplot(num_planes+1, num_modes, sub2ind([num_modes, num_planes+1], kk, ii), 'Parent', fig_spatial_modes);
            hold(ax(ii, kk), 'on');
        end
    end
    
    ax(num_planes+1, 1) = subplot(num_planes+1, num_modes, [(num_planes*num_modes)+1 (num_modes*num_planes)+num_modes], 'Parent', fig_spatial_modes);
    hold(ax(num_planes+1, 1), 'on');

    threshold = 1e-6; % NOTE: should be a parameter
    V.vx(abs(V.vx) < threshold) = 0;
    V.vy(abs(V.vy) < threshold) = 0;
    V.vz(abs(V.vz) < threshold) = 0;

    Vnorm =  sqrt(V.vx.^2+ V.vy.^2+ V.vz.^2);
    
    % Get overall direction along each axis = +/-/null 
    Vx_sign = sign(sum(V.vx));
    Vy_sign = sign(sum(V.vy));
    Vz_sign = sign(sum(V.vz));
    
    % NOTE: maybe enable this check to avoid zero division
    %Vnorm(Vnorm < 2^-9) = 1;
    
    cmap = plasma(num_modes+2);
    cmap = cmap(1:num_modes, :);
    cmap = cmap(end:-1:1, :);

    % Orthognal plane indices
    xy = 1;
    xz = 2;
    zy = 3;
    
    scaling_vxyz = 32;
    axes_offset = 4;
    x_lims = [min(X(:))-axes_offset, max(X(:))+axes_offset];
    y_lims = [min(Y(:))-axes_offset, max(Y(:))+axes_offset];
    z_lims = [min(Z(:))-axes_offset, max(Z(:))+axes_offset];
    
    draw_arrow_fun = @(axh, x, y, z, varargin) vfield3(axh, x(1), y(1), z(1), x(2)-x(1), y(2)-y(1), z(2)-z(1), varargin{:});    
    mode_str = cell(num_modes, 1);
    colormap(cmap)
    for kthmode = 1:num_modes
        this_color = cmap(:, kthmode);
        [faces,vertices,colors] = quiver3Dpatch(X, Y, Z, ...
                                V.vx(:, kthmode), ...
                                V.vy(:, kthmode), ...
                                V.vz(:, kthmode), ...
                                this_color(ones(1, numel(V.vz(:, kthmode))), :), [10 11]); 
        hp=patch(ax(xy, kthmode), 'faces', faces,'vertices', vertices,'cdata', colors,'edgecolor','none','facecolor','flat');

        ax(xy, kthmode).DataAspectRatio = [1 1 1];

        [faces,vertices,colors] = quiver3Dpatch(X, Y, Z, ...
                                V.vx(:, kthmode), ...
                                V.vy(:, kthmode), ...
                                V.vz(:, kthmode), ...
                                this_color(ones(1, numel(V.vz(:, kthmode))), :), [10 11]); 
        hp=patch(ax(xz, kthmode), 'faces', faces,'vertices', vertices,'cdata', colors,'edgecolor','none','facecolor','flat');

        ax(xz, kthmode).DataAspectRatio = [1 1 1];
                [faces,vertices,colors] = quiver3Dpatch(X, Y, Z, ...
                                V.vx(:, kthmode), ...
                                V.vy(:, kthmode), ...
                                V.vz(:, kthmode), ...
                                this_color(ones(1, numel(V.vz(:, kthmode))), :), [10 11]); 
        hp=patch(ax(zy, kthmode), 'faces', faces,'vertices', vertices,'cdata', colors,'edgecolor','none','facecolor','flat');

        ax(zy, kthmode).DataAspectRatio = [1 1 1];
        % XY
        draw_arrow_fun(ax(xy, kthmode), [0 scaling_vxyz*Vx_sign(kthmode)], [0 0], [z_lims(end) z_lims(end)], 'color', [1 0 0]);
        draw_arrow_fun(ax(xy, kthmode), [0 0], [0 scaling_vxyz*Vy_sign(kthmode)], [z_lims(end) z_lims(end)], 'color', [0 1 0]);
   
        % XZ
        draw_arrow_fun(ax(xz, kthmode), [0 scaling_vxyz*Vx_sign(kthmode)], [y_lims(1) y_lims(1)], [0 0], 'color', [1 0 0]);
        draw_arrow_fun(ax(xz, kthmode), [0 0], [y_lims(1) y_lims(1)], [0 scaling_vxyz*Vz_sign(kthmode)], 'color', [0 0 1]);
        
        % ZY
        draw_arrow_fun(ax(zy, kthmode), [x_lims(end) x_lims(end)], [0 0], [0 scaling_vxyz*Vz_sign(kthmode)], 'color', [0 0 1]);
        draw_arrow_fun(ax(zy, kthmode), [x_lims(end) x_lims(end)], [0 scaling_vxyz*Vy_sign(kthmode)], [0 0], 'color', [0 1 0]);
        
        ax(xy, kthmode).View = [ 0 90];
        ax(xz, kthmode).View = [ 0  0];
        ax(zy, kthmode).View = [90  0];

        ax(xy, kthmode).Title.String = sprintf('Spatial mode %i\n Var = %0.1f%%', kthmode, prct_var(kthmode));
        mode_str{kthmode} = sprintf('%i', kthmode);
        
        % Axis Limits
        ax(xy, kthmode).XLim = x_lims;
        ax(xy, kthmode).YLim = y_lims;
        ax(xy, kthmode).ZLim = z_lims;
        
        ax(xz, kthmode).XLim = x_lims;
        ax(xz, kthmode).YLim = y_lims;
        ax(xz, kthmode).ZLim = z_lims;
        
        ax(zy, kthmode).XLim = x_lims;
        ax(zy, kthmode).YLim = y_lims;
        ax(zy, kthmode).ZLim = z_lims;
        
        axis(ax(xy, kthmode), 'off')
        axis(ax(xz, kthmode), 'off')
        axis(ax(zy, kthmode), 'off')

    end
    
     smooth_window = 2; % number of samples to smooth the envelope
     [~, Upeak] = envelope(U, smooth_window, 'peak');
     max_u_val = 1.1*max(abs(Upeak(:)));
     ulims = [-max_u_val max_u_val];
     
     for kthmode=1:num_modes
         plot(ax(num_planes+1, 1), time_vec, U(:, kthmode), 'Color', cmap(kthmode, :))
     end
     ax(num_planes+1, 1).Title.String = sprintf('Temporal modes');
     ax(num_planes+1, 1).YLim = ulims;
     ax(num_planes+1, 1).XLim = [time_vec(1), time_vec(end)];
     line(ax(num_planes+1, 1), ax(num_planes+1, 1).XLim, [0 0], 'Color', 'k', 'LineStyle', '--')
     ax(num_planes+1, 1).XLabel.String = 'Time';
     ax(num_planes+1, 1).YLabel.String = 'Mode score';
     ax(num_planes+1, 1).Box = 'on';
     lg_obj = legend(ax(num_planes+1, 1));
     lg_obj.String = mode_str;
     lg_obj.Title.String = 'Modes';
     lg_obj.Orientation = 'horizontal';
     
 end % function plot_svd_modes()