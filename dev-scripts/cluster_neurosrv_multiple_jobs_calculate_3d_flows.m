function cluster_neurosrv_multiple_jobs_calculate_3d_flows(idx_chunk)
% Script to process chunks of simulated data on neurosrv

    load('/home/paulasl/Code/neural-flows/demo-data/long_cd_ictime50_seg7999_outdt1_d1ms_W_coupling0.6_trial1.mat', 'soln');
    %in1 = load('/headnode2/paula123/Code/neural-flows/demo-data/W_c1_d1ms_trial1.mat');
    %soln = in1.nodes.'; 
    load('513COG.mat', 'COG')

    % window size
    ws = 8193;
    %ws=32;
    % shift step
    shift_step = ws - 64;
    %shift_step = ws - 4;
    datalen  = size(soln, 2);
    idx = ws:shift_step:datalen;
    if idx_chunk < length(idx)+1
        idx_start = idx(idx_chunk)-ws+1; 
        idx_stop =  idx(idx_chunk);
    else
        idx_start = idx(end);
        idx_stop = datalen;
    end
    data = soln(:, idx_start:idx_stop)';
    locs = COG;

    clear COG soln

    % Cluster properties
    local_cluster = parcluster('local');
    local_cluster.NumWorkers = 24;   % This should match the requested number of cpus
    parpool(local_cluster.NumWorkers, 'IdleTimeout', 1800);

    % Change directory to scratch, so temp files will be created there
    cd /home/paulasl/scratch

    % Options for the flow computation
    options.data_interpolation.file_exists = false;
    
    % Resolution
    options.hx = 3;
    options.hy = 3;
    options.hz = 3;
    options.ht = 1;
    
    % Slice of data
    options.chunk = idx_chunk;
    options.chunk_start = idx_start;
    options.chunk_stop  = idx_stop;
    
    % Flow calculation
    options.flow_calculation.init_conditions = 'random';
    options.flow_calculation.seed_init_vel = 42;
    options.flow_calculation.alpha_smooth   = 0.1;
    options.flow_calculation.max_iterations = 64;
    options.sing_analysis.detection = true;    
    options.sing_analysis.detection_datamode  = 'vel';

    % Tic
    tstart = string(datetime('now'));
    fprintf('%s%s\n', ['Started: ' tstart])

    % Do the stuff 
    main_neural_flows_hs3d_scatter(data, locs, options);
    
    % Toc
    tend = string(datetime('now'));
    fprintf('%s%s\n', ['Finished: ' tend])
    tictoc = etime(datevec(tend), datevec(tstart)) / 3600;
    fprintf('%s%s%s\n\n', ['Elapsed time: ' string(tictoc) ' hours'])

end % cluster_yossarian_multiple_jobs_calculate_3d_flows()
