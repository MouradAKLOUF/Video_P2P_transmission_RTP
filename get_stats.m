function get_stats(time)

% get stats about the system ...

%% call global Vars
global scheduler;
global emission_bufferLevel_pckts;
global reception_bufferLevel_pckts;
global emission_bufferLevel_bits;
global reception_bufferLevel_bits;
global emission;
global reception;

%% update  scheduler

stat={[time+2],'get_stats'};              %get_stats
scheduler = [scheduler; stat];


%%
indx=floor(time/2)+1;
%Trace buffer level
emission_bufferLevel_bits(indx)= get_buffer(emission, 'bit_size');
reception_bufferLevel_bits(indx)= get_buffer(reception, 'bit_size');
emission_bufferLevel_pckts(indx)= get_buffer(emission, 'size');
reception_bufferLevel_pckts(indx)= get_buffer(reception, 'size');
 
end
