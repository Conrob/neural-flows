function test_travellingwave3d_grid()

% Generate data
 options.hx = 2;
 options.hy = 2;
 options.hz = 2;
 options.ht = 0.5;
 [wave3d, X, Y, Z, ~] = generate_travellingwave3d_grid('visual_debugging', true, 'hxyz', options.hx, 'ht', options.ht, 'velocity', 1);
 
 options.flow_calculation.init_conditions = 'random';
 options.flow_calculation.seed_init_vel = 42;
 options.flow_calculation.alpha_smooth   = 0.1;
 options.flow_calculation.max_iterations = 128;

 mfile_flows = main_neural_flows_hs3d_grid(wave3d, X, Y, Z, options);

 fig_hist = figure('Name', 'nflows-test-travellingwave3d-grid-hs3d');

 subplot(1, 3, 1, 'Parent', fig_hist)
 histogram(mfile_flows.ux(2:end-1, 2:end-1, 2:end-1, :))
 xlabel('ux')
 
 subplot(1, 3 ,2, 'Parent', fig_hist)
 histogram(mfile_flows.uy(2:end-1, 2:end-1, 2:end-1, :))
 xlabel('uy')
 
 subplot(1, 3, 3, 'Parent', fig_hist)
 histogram(mfile_flows.uz(2:end-1, 2:end-1, 2:end-1, :))
 xlabel('uz')
  
 %
 %for tt=1:22; pcolor3(squeeze(wave3d(tt, :, :, :))); caxis([-40 10]); pause(0.5); clf;end
 %
 %for tt=1:21; clf; pcolor3(ux(:, :, :, tt)); caxis([0 3.5]);colorbar;pause(0.5);end
 
 
end % function test_travellingwave3d_grid()