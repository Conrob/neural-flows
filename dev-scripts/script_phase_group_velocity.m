% This script explores the differences between using the amplitude, the phase
% and the unwrapped phase to determine the group velocity of a travelling. 
% PSL - Dec 2019

% Example: phase velocity slower than group velocity and in opposite
% direction
% Wave parameters
fc  = 4;    % Hz
nuc = 2;    % 1/m
df  = 0.25; % Hz
dnu = 0.25; % 1/m

w1  = 2*pi*(fc+df);    %angular frequency rad/s
k1x = 2*pi*(nuc-dnu);  %angular frequency wavenumber rad/m
k1y = 2*pi*(nuc-dnu);  %angular frequency wavenumber rad/m
w2  = 2*pi*(fc-df);    %angular frequency rad/s
k2x = 2*pi*(nuc+dnu);  %angular frequency wavenumber rad/m
k2y = 2*pi*(nuc+dnu);  %angular frequency wavenumber rad/m

k2 = sqrt(k2x.^2 + k2y.^2); %radial angular wavenumber rad/m
k1 = sqrt(k1x.^2 + k1y.^2); %radial angular wavenumber rad/m

% Group velocity
dw = (w2-w1);
dk = (k2-k1);
vg = dw / dk;

% Spatiotemporal grid 
dx = 0.02;
dy = 0.02;
dt = 0.02;
xx = 0:dx:2;
yy = 0:dy:2;
tt = 0:dt:5;
[x, y, t] = meshgrid(xx, yy, tt);

wave1 = cos(w1.*t-k1x.*x+k1y.*y);
wave2 = cos(w2.*t-k2x.*x+k2y.*y);

% Because imagscale flips the array
wave1 = fliplr(wave1);
wave2 = fliplr(wave2);
wv = wave1 + wave2;

%% Plotting of results
[pdg_sentinel] = set_default_groot({'light', 'medium'});
save_formats = {'tiff', 'jpeg'};
output_path = '~/Work/Articles/neural-flows-article/figures';
%% Figure 2 -- 2D+t wave
nr = 3;
nc = 4;
figure2_handle = figure('Name', 'fig2');
% Assumes figure units are in cm
figure2_handle.Position = [-35.0838  14.2875 28 19];

for kk=1:8
   ax(kk) = subplot(nr, nc, kk);
   hold(ax(kk), 'on')
end

ax(9)  = subplot(nr, nc, 9);
hold(ax(9), 'on')

ax(10) = subplot(nr, nc, [10 12]);
hold(ax(10), 'on')

alpha_data = 0.75;
x_idx = floor(length(xx)/2);
y_idx = floor(length(yy)/2);

% First frame -- wave 1
imagesc(ax(1), xx, yy, wave1(:, :, 1), 'AlphaData', alpha_data);
ax(1).YDir = 'reverse';
ax(1).XAxisLocation = 'top';
ax(1).YLabel.String = 'y [m]';
ax(1).XLabel.String = 'x [m]';

plot(ax(1), xx(x_idx), yy(y_idx), 'wo', 'markersize', 8, 'markeredgecolor', 'k', 'markerfacecolor', 'w')
plot(ax(1), xx(x_idx), yy(y_idx), 'kx', 'markersize', 8)

% Time course -- wave 1
plot(ax(2), tt, squeeze(wave1(y_idx, x_idx, :)), 'k');
ax(2).XAxisLocation = 'top';
ax(2).XLim = [0 2];
ax(2).XLabel.String = 'time [s]';
ax(2).YLabel.String = 'w_1(x_0, y_0, t)';


% First frame -- wave 2
imagesc(ax(3), xx, yy, wave2(:, :, 1), 'AlphaData', alpha_data);
ax(3).YDir = 'reverse';
ax(3).XAxisLocation = 'top';
ax(3).YLabel.String = 'y [m]';
ax(3).XLabel.String = 'x [m]';

plot(ax(3), xx(x_idx), yy(y_idx), 'w+', 'markersize', 10)
plot(ax(3), xx(x_idx), yy(y_idx), 'wo', 'markersize', 8, 'markeredgecolor', 'k', 'markerfacecolor', 'w')
plot(ax(3), xx(x_idx), yy(y_idx), 'kx', 'markersize', 8)

% Time course -- wave 2
plot(ax(4), tt, squeeze(wave2(y_idx, x_idx, :)), 'k');
ax(4).XAxisLocation = 'top';
ax(4).XLim = [0 2];
ax(4).XLabel.String = 'time [s]';
ax(4).YLabel.String  = 'w_2(x_0, y_0, t)';

% Frames - wave sum
frames = [1 20 50 80];
for kk=1:length(frames)
    colormap(redyellowblue(256, 'rev'))
    imagesc(ax(kk+4), xx, yy, wv(:, :, frames(kk)), 'AlphaData', alpha_data);
    ax(kk+4).YDir = 'reverse';
    ax(kk+4).XAxisLocation = 'top';
    ax(kk+4).YLabel.String = 'y [m]';
    ax(kk+4).XLabel.String = 'x [m]';
end

plot(ax(5), xx(x_idx)*ones(length(yy), 1), yy,  'k--')

% Wave in 1D
data =  wv(:, x_idx, 1);
surf(ax(9), [yy(:) yy(:)], [data(:) data(:)], [data(:) data(:)], ...  % Reshape and replicate data
     'FaceColor', 'none', ...    % Don't bother filling faces with color
     'EdgeColor', 'interp', ...  % Use interpolated color for edges
     'EdgeAlpha', 0.9,...
     'LineWidth', 4);
colormap(redyellowblue(256, 'rev'))
ax(9).XLabel.String = 'y [m]';
ax(9).YLabel.String = 'w(x_0, y, t_0) ';

% Markers
plot(ax(10), tt, squeeze(wv(y_idx, x_idx, :)), 'k')
plot(ax(10), tt(frames(2:end)), squeeze(wv(y_idx, x_idx, frames(2:end))), 'r.', 'markersize', 20)
ax(10).XLim = [0 5];
xlabel('time [s]')
ylabel('w(x_0, y_0, t) ')


plot(ax(6), xx(x_idx), yy(y_idx), 'wo', 'markersize', 8, 'markeredgecolor', 'k', 'markerfacecolor', 'w')
plot(ax(6), xx(x_idx), yy(y_idx), 'kx', 'markersize', 8)

plot(ax(7), xx(x_idx), yy(y_idx), 'wo', 'markersize', 8, 'markeredgecolor', 'k', 'markerfacecolor', 'w')
plot(ax(7), xx(x_idx), yy(y_idx), 'kx', 'markersize', 8)

plot(ax(8), xx(x_idx), yy(y_idx), 'wo', 'markersize', 8, 'markeredgecolor', 'k', 'markerfacecolor', 'w')
plot(ax(8), xx(x_idx), yy(y_idx), 'kx', 'markersize', 8)
%% Frames - wave sum - amplitude
vidfile = VideoWriter('wave_velocity.avi');
phi = angle(hilbert(wv));

open(vidfile);

figure2a_handle = figure('Name', 'fig2a');
ax_mov = subplot(1,1,1);
axis equal
for kk=1:length(tt)
    colormap(redyellowblue(256, 'rev'))
    imagesc(ax_mov, xx, yy, wv(:, :, kk), 'AlphaData', alpha_data);
    ax_mov.YDir = 'reverse';
    ax_mov.XAxisLocation = 'top';
    ax_mov.YLabel.String = 'y [m]';
    ax_mov.XLabel.String = 'x [m]';
    pause(0.1)
    drawnow
    f = getframe(figure2a_handle);
    writeVideo(vidfile, f);
end
 close(vidfile)
 
%% Frames - wave sum - phase
vidfile = VideoWriter('wave_velocity_phase.avi');
phi = angle(hilbert(wv));

open(vidfile);

figure2b_handle = figure('Name', 'fig2b');
ax_mov = subplot(1,1,1);
axis equal
cmap = pmkmp_new('ostwald_o', 256);
for kk=1:length(tt)
    colormap(cmap) % from neuropatt
    imagesc(ax_mov, xx, yy, phi(:, :, kk), 'AlphaData', alpha_data);
    ax_mov.YDir = 'reverse';
    ax_mov.XAxisLocation = 'top';
    ax_mov.YLabel.String = 'y [m]';
    ax_mov.XLabel.String = 'x [m]';
    pause(0.1)
    drawnow
    f = getframe(figure2b_handle);
    writeVideo(vidfile, f);
end
 close(vidfile)

%% Figure 3 - plot slice across one spatal dimension, at 4 different time points  
figure3_handle = figure('Name', 'fig3');
nr = 4;
nc = 1;

for kk=1:4
   ax(kk) = subplot(nr, nc, kk, 'Parent', figure3_handle);
   hold(ax(kk), 'on')
end

figure3_handle.Position = [ -35.0573   14.2081 13.6 19.2];

fl1 = 50; % samples to estimate the envelope
frames = [1 5 10 15];

for kk=1:4
    data = squeeze(wv(:, x_idx, frames(kk)));
    [up1,lo1] = envelope(data, fl1,'analytic');
    surf(ax(kk), [yy(:) yy(:)], [data(:) data(:)], [data(:) data(:)], ...  % Reshape and replicate data
     'FaceColor', 'none', ...    % Don't bother filling faces with color
     'EdgeColor', 'interp', ...  % Use interpolated color for edges
     'EdgeAlpha', 0.9,...
     'LineWidth', 4);     
    colormap(redyellowblue(256, 'rev'))
    plot(ax(kk), yy, up1, 'k', 'linewidth', 2)
    plot(ax(kk), yy, lo1, 'k', 'linewidth', 2)
    ax(kk).YLim = [-2 2];
    ax(kk).XLim = [0 2];
    ax(kk).Box = 'on';
    t_time = num2str(tt(frames(kk)), '%.2f');
    ax(kk).YLabel.String = ['f(x_0, y, ', t_time, ' )'];
end

ax(4).XLabel.String = 'y [m]';

% Create lines across subplots
annotation(figure3_handle,'line',[0.43 0.315], ...
                                 [0.88 0.25],'LineStyle','--');

% Create line
annotation(figure3_handle,'line',[0.52 0.63],...
                                 [0.84 0.185],'LineStyle','-.');

%% Figure 4 -- neuropatt amplitude-based estimation raw signal
wv_t = wv(1:35, 1:35, :); 
NeuroPattGUI(wv_t, 50)

% Get figure handle
figure_handle = figure(1);
ax(1) = figure_handle.Children(5);
ax(2) = figure_handle.Children(3);

ax(1).XLim = [10 30];
ax(1).YLim = [10 30];
ax(2).XLim = [10 30];
ax(2).YLim = [10 30];

ax(1).Children.Color =  [0.5500 0.5500 0.5500];
ax(2).Children.Color =  [0.5500 0.5500 0.5500];
figure_handle.Children(4).Children(2).Color = [0.5500 0.5500 0.5500];
figure_handle.Children(1).Children(2).Color = [0.5500 0.5500 0.5500];
%%
close all
%% Figure 5 -- neuropatt amplitude-based estimation envelope of signal
env   = abs(hilbert(wv));
env   = env(25:65, 25:65, 20:end-20);

NeuroPattGUI(env, 50)

figure_handle = figure(1);
ax(1) = figure_handle.Children(5);
ax(2) = figure_handle.Children(3);

ax(1).XLim = [10 30];
ax(1).YLim = [10 30];
ax(2).XLim = [10 30];
ax(2).YLim = [10 30];

ax(1).Children.Color =  [0.5500 0.5500 0.5500];
ax(2).Children.Color =  [0.5500 0.5500 0.5500];
figure_handle.Children(4).Children(2).Color = [0.5500 0.5500 0.5500];
figure_handle.Children(1).Children(2).Color = [0.5500 0.5500 0.5500];
%% 
close all
%% Figure 6 -- neuropatt phase-based estimation -- hilbert transform of raw signal

phi_env   = angle(hilbert(wv)); % wrapped phases
phi_env = phi_env(25:65, 25:65, 20:end-20);
NeuroPattGUI(phi_env, 50)

figure_handle = figure(1);
ax(1) = figure_handle.Children(5);
ax(2) = figure_handle.Children(3);

ax(1).XLim = [10 30];
ax(1).YLim = [10 30];
ax(2).XLim = [10 30];
ax(2).YLim = [10 30];

ax(1).Children.Color =  [0.5500 0.5500 0.5500];
ax(2).Children.Color =  [0.5500 0.5500 0.5500];
figure_handle.Children(4).Children(2).Color = [0.5500 0.5500 0.5500];
figure_handle.Children(1).Children(2).Color = [0.5500 0.5500 0.5500];
%%
close all
%% Figure 7 -- neuropatt phase-based estimation -- hilbert transform of envelope
env     = abs(hilbert(wv));
phi_env = angle(hilbert(env));
phi_env = phi_env(25:65, 25:65, 20:end-20);

NeuroPattGUI(phi_env, 50)
figure_handle = figure(1);
ax(1) = figure_handle.Children(5);
ax(2) = figure_handle.Children(3);

ax(1).XLim = [10 30];
ax(1).YLim = [10 30];
ax(2).XLim = [10 30];
ax(2).YLim = [10 30];

ax(1).Children.Color =  [0.5500 0.5500 0.5500];
ax(2).Children.Color =  [0.5500 0.5500 0.5500];
figure_handle.Children(4).Children(2).Color = [0.5500 0.5500 0.5500];
figure_handle.Children(1).Children(2).Color = [0.5500 0.5500 0.5500];
