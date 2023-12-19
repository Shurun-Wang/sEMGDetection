clear all;
c_n = 1; % choose the channel number
result_list= load(['results/12_',num2str(c_n),'.mat']);

en_g_list = result_list.en_g_list;
semg = result_list.semg;

         
%% hyper-parameter
lambda_h = 0.15; % high factor   
lambda_l = 0.05; % low factor    
detection_range = 100; % detection range
act_flag = 0; 
global_flag = 0; 
on_buffer = [];
off_buffer = [];

th = min(en_g_list)+lambda_h*(max(en_g_list)-min(en_g_list));
tl = min(en_g_list)+lambda_l*(max(en_g_list)-min(en_g_list));
%% scanning from begin to end
len = length(en_g_list);
i = 1;
while i+detection_range-1 <= len
    if act_flag == 0
        thread = th;
    elseif act_flag == 1
        thread = tl;
    end 
    if sum(en_g_list(i:i+detection_range-1) >= thread)==detection_range && global_flag == 0
        on_buffer = [on_buffer, i];
        act_flag = 1;
        global_flag = 1;
    end
    if sum(en_g_list(i:i+detection_range-1) < thread)==detection_range && global_flag == 1
        off_buffer = [off_buffer, i];
        act_flag = 0;
        global_flag = 0;
    end    
    i = i + 1;
end

on_position = on_buffer;
off_position = off_buffer;
subplot(211)
plot(semg)
hold on
i = 1;
while i <= length(on_position)
plot([on_position(i),on_position(i)], [-1, 1], 'r')
i = i+ 1;
hold on
end
i = 1;
while i <= length(off_position)
plot([off_position(i),off_position(i)], [-1, 1], 'g')
i = i+ 1;
hold on
end
subplot(212)
plot(en_g_list)
hold on
i = 1;
while i <= length(on_position)
plot([on_position(i),on_position(i)], [0, 1], 'r')
i = i+ 1;
hold on
end
i = 1;
while i <= length(off_position)
plot([off_position(i),off_position(i)], [0, 1], 'g')
i = i+ 1;
hold on
end