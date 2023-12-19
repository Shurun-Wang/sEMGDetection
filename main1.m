clear

for channel=2:1:9
    semgs = csvread('data_test/12kg.csv',1);
    semg = semgs(:,channel); % single channel sEMG
    channel_name = num2str(channel - 1);
    semg = semg /1000; % unit£ºmv
    
    %% define hyper-parameter
    fs = 2000; % sampling frequency
    seg = 300; % data length
    nap = 1;  % frame slide
    r = 0.25;   % tolerance 
    m = 2; % embbeded dimension
    tau = 3; % scale factor 
    SNR = 5; % signal-to-noise ratio
    noise_type = 0; % 0£ºno noise  1:tonic spikes    2:ma  
    r_value = r * std(semg); 
    %% adding noise¡¢signal segmentation
    if noise_type==1
        % adding ts noise
        len = length(semg);
        r_semg_tmp = zeros(len,1);
        t = 1;
        while t <= len
            noise_tmp = 10*(rand(1,1)-0.5);
            r_semg_tmp(t) = noise_tmp;
            t = t + unidrnd(100);
        end
        semg = add_noisedata(semg,r_semg_tmp,fs,fs,SNR); 
    elseif noise_type==2
        % adding ma noise
        move_artifact = load(['data_test/','ecg.mat']).ecg;
        move_artifact = move_artifact(2800:4500)+0.109569332669841;
        tmp = zeros(length(semg),1);
        tmp(5000:5000+1700) = move_artifact;
        tmp(17000:17000+1700) = move_artifact;
        tmp(26000:26000+1700) = move_artifact;
        tmp(35000:35000+1700) = move_artifact;
        tmp(43000:43000+1700) = move_artifact;
        tmp(50000:50000+1700) = move_artifact;
        tmp(59000:59000+1700) = move_artifact;
        tmp(67000:67000+1700) = move_artifact;
        tmp(75000:75000+1700) = move_artifact;
        tmp(82000:82000+1700) = move_artifact;
        tmp(91000:91000+1700) = move_artifact; 
        semg = add_noisedata(semg,tmp,fs,fs,SNR); 
    end

%     subplot(611)
%     plot(semg)

    semg_seg = enframe(semg, seg, nap); % segmentation function
    frame_len = length(semg_seg(:,1)); 

    en_g_list = zeros(frame_len,1); 
    for i=1:frame_len
        en_g_list(i) = rcmse_value(semg_seg(i,:),m,tau, r_value);
    end
    en_g_list(en_g_list==inf) = nan;
    en_mean = nanmean(en_g_list);
    nan_no = numel(en_g_list(isnan(en_g_list)));
    save(['results/12_',channel_name],'en_g_list','semg');
 end

