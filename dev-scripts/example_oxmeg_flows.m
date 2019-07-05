% This scripts tests the estimation of neural flows on curved manifolds, and 
% the classification of the flow on each triangle of the mesh.
% Critical points are classified either as saddles or nodes (sinks, or
% sources). Further analysis is required to distinguish between sinks/sources. 

% Author: Paula Sanz-Leon, QIMR June 2019

% Load surface
load('mesh_hcp'); 

rh = 2:242;
lh = 2:241;

cortex.vertices = double(white.right.vertices);
cortex.faces = double(white.right.faces);

tr = triangulation(cortex.faces, cortex.vertices);
cortex.vertex_normals = tr.vertexNormal;
cortex.face_barycentres = get_triangle_barycenter(cortex.vertices(:, 1), ...
                                                  cortex.vertices(:, 2), ...
                                                  cortex.vertices(:, 3));

% Load data
load('sub15-1to45Hz-mesh-R')

% Pad with zeros cause the surface has more vertices than the 'cortical' data
datameg  = zeros(size(data, 1), size(cortex.vertices, 1));
good_idx = find(white.right.atlas);
bad_idx  = find(~white.right.atlas);


% Place the data in the right spot
for kk=1:length(good_idx)
   datameg(:, good_idx(kk)) = data(:, kk+1); % The plus 1 is because of the addition of the time vector at the top
end

% Generate timevec -- not really used at the moment
time_data = data(:, 1);
fs = 1./(time_data(2) - time_data(1));

flo = 5;
fhi = 15;
[f, Y, P] = rfft(data(:, rh), fs, 2048, true, false, true);
dataf = bandpass_filter(data(:, rh), flo, fhi, 5, fs);

%% Estimate neural flows
hs_smoothness = 1;
idx_start = 1;   
idx_end   = 62500;

% NOTE: the calculation takes about 50s for input data of size [v: 16384 x t: 201] 
tic;[flow_fields, int_flow, ~, ~, ~, ~] = estimate_flow_tess(datameg(:, :).', ...
                                                      cortex, time_data, ...
                                                      idx_start, idx_end, ...
                                                      hs_smoothness);toc;
                                                  
                                                  
%% Set up graphics objects

tt=1;
[surf_handle, fax] = plot_surf(cortex, datameg(tt, :), 'bgr');
hold(fax.axes, 'on')
quiv_handle = quiver3(fax.axes, cortex.vertices(:, 1), ...
                                cortex.vertices(:, 2), ...
                                cortex.vertices(:, 3), ...
                                flow_fields(:, 1, tt), ...
                                flow_fields(:, 2, tt), ...
                                flow_fields(:, 3, tt), ...
                                2, 'color', [0.5 0.5 0.5 0.1], 'linewidth', 0.5);


xlims = fax.axes.XLim;
ylims = fax.axes.YLim;
zlims = fax.axes.ZLim;

%%
max_pos_val = max( datameg(:));
max_neg_val = max(-datameg(:));
max_val = 0.25*min([max_pos_val, max_neg_val]);
caxis([-max_val max_val])

%% Make a movie out of the data
for tt=1:200;%dx_end-1
    set(quiv_handle, 'UData', flow_fields(:, 1, tt), ...
                     'VData', flow_fields(:, 2, tt), ...
                     'WData', flow_fields(:, 3, tt))
    
    %cp_idx = find(poincare_index(:, tt) ==1 );
    %set(cp_handle, 'XData', cortex.face_barycentres(cp_idx, 1), ...
    %               'YData', cortex.face_barycentres(cp_idx, 2), ...
    %               'ZData', cortex.face_barycentres(cp_idx, 3))
               
    set(surf_handle, 'FaceVertexCData', datameg(tt, :).')
    
    %Hacky bit: Avoid jitter from frame to frame
    fax.axes.XLim = xlims;
    fax.axes.YLim = ylims;
    fax.axes.ZLim = zlims;
    caxis([-max_val max_val])
    pause(0.1)
    TheMovie(1,tt) = getframe(fax.figure);
end

%% Write movie to file
videoname = strcat('oxmeg_dataset');
v = VideoWriter([ videoname '.avi']);
v.FrameRate = 10;

open(v);
for kk=1:size(TheMovie,2)
   writeVideo(v,TheMovie(1, kk)) 
end
close(v)