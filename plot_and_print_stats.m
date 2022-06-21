function [avrg_psnr, std_psnr, avrg_rate,  std_rate, nbr_switches, nbr_lost_imgs,  total_lost_pkts, stableRate_avrgTime_msec, stableRate_stdTime_msec] = plot_and_print_stats ()

plot_= true;

%% call global Vars

global not_played_frames;
global frameDuration_msec;
global decided_Rate_Levels;
global Num_Imgs_;
global sequence;
global Case;
global current_R;
global initial_playBack_delay;
global Dictionary;
global maxRTPsize;
global emission_bufferLevel_pckts;
global reception_bufferLevel_pckts;
global emission_bufferLevel_bits;
global reception_bufferLevel_bits;
global T;
global buff_max_size;
global actions_vector;

global perfectly_played;
global img_psnr;
global safe_int;
global videoRate;

global recBuffLevelInPkts;
global emiBuffLevelInPkts;

global recBuffLevel,
global emiBuffLevel,
%% ploting evolution of emission and reception bufferLevel

if plot_ ==true
    
time=(0:2:T);  %msec
maxi=max( max(reception_bufferLevel_bits), max(emission_bufferLevel_bits)) + maxRTPsize;
figure,
subplot(3,1,1); plot((find(current_R>0)+1),current_R(current_R>0),'.-r');                                                       title('output Rate');xlabel('time'); ylabel('Kbps'); 
subplot(3,1,2); plot(time,emission_bufferLevel_bits,'.-r');                             ylim([-1 maxi]);title('emission bufferLevel [byts]');xlabel('time'); ylabel('');
subplot(3,1,3); plot(time,reception_bufferLevel_bits,'.-b');                            ylim([-1 maxi]);title('reception bufferLevel [byts]');xlabel('time'); ylabel('');

figure,
maxi=max( max(emission_bufferLevel_pckts), max(reception_bufferLevel_pckts)) + 3;
subplot(3,1,1); plot((find(current_R>0)+1),current_R(current_R>0),'.-r');                                                       title('output Rate');xlabel('time'); ylabel('Kbps');
subplot(3,1,2); plot(time,emission_bufferLevel_pckts,'.-r');                           ylim([0 maxi]);title('emission bufferLevel [pckts]');xlabel('time'); ylabel('');
subplot(3,1,3); plot(time,reception_bufferLevel_pckts,'.-b');                          ylim([0 maxi]);title('reception bufferLevel [pckts]');xlabel('time'); ylabel('');


figure,
time_axes=2:Num_Imgs_;
subplot(3,1,1); plot(time_axes,current_R(current_R>0),'.-b'); 
time_axes=1:Num_Imgs_;
subplot(3,1,2); plot(time_axes, emiBuffLevel ,'.-r');   title('emission bufferLevel [img] ');xlabel('img indx');  
subplot(3,1,3); plot(time_axes, recBuffLevel ,'.-r');   title('reception bufferLevel [img] ');xlabel('img indx');  

end

%% getting the saved infos about images

l= length(sequence);
img_sizes=zeros(l ,1);   

perfectly_decoded=zeros(l ,1);
pkt_loss=zeros(l ,1);    

start_encod=zeros(l ,1);    
trans_time=zeros(l ,1);    
rec_time=zeros(l ,1);   
end_deco=zeros(l ,1);   

for i=1:1:l
    img=sequence(i);
    
    start_encod(i)=get_image(img, 'start_encod');    
    trans_time(i)=get_image(img, 'end_encod');    
    rec_time(i)=get_image(img, 'end_trans');  
    end_deco(i)=get_image(img, 'end_decod');  
    
    img_sizes(i)=get_image(img, 'size');   
    perfectly_decoded(i)=get_image(img, 'decodable');    
    pkt_loss(i)=(get_image(img, 'lost')/Dictionary(i,2))*100 ;  
   
end

%% for each img, showing it size, if its decoded, played, how much lost 
if plot_ ==true
figure,
plot(safe_int,'*-r')
hold on
plot(0*ones(l),'-b')
hold off
ylim([-2+min(safe_int) max(safe_int)+5]);
title(' time until playing the img; -1 means lost ');xlabel('img indx'); ylabel('msec ');

figure,
subplot(4,1,1); plot(img_sizes,'*-r');                            title(' img size (Bytes) ');xlabel('img indx'); ylabel(' ');
subplot(4,1,2); plot(perfectly_decoded,'*-r');                title('decoded imgs (1: true, 0: false)'); ylim([0 1.4]); xlabel('img indx'); ylabel('yes/no');
subplot(4,1,3); plot(pkt_loss,'*-r');                              title(' pkt loss (%) ');xlabel('img indx'); ylabel(' ');
subplot(4,1,4); plot(perfectly_played,'*-r');                  title('played imgs (1: true, 0: false)'); ylim([0 1.4]); xlabel('img indx');ylabel('yes/no');
end

%% plotinng the stairs
if false
figure,
stairs(start_encod,start_encod+initial_playBack_delay,'r')
hold on
stairs(start_encod,trans_time,'-c')
stairs(start_encod,rec_time,'-g')
stairs(start_encod,end_deco,'b')
hold off
title('');xlabel('trans time'); ylabel('rec time');
legend('playBack setpoint', 'end encoding/start trans', 'reception time' , 'end decoding' )
end

%% ploting outputRate (bandwidth) / decided video Rates / PSNR
if plot_ ==true

   
time_axes=2:Num_Imgs_;
figure,
subplot(2,1,1); plot(time_axes,current_R(current_R>0),'*-b');    title('output Rate');xlabel('time'); ylabel('Kbps'); 
hold on
time_axes=1:Num_Imgs_;
plot(time_axes,videoRate,'*-r');            legend
plot(time_axes,not_played_frames,'*g');            xlabel('time [msec]'); ylabel('Kbps'); legend('bandwidth', 'received video Rate ', ' not played frames')
ylim([-2 max(current_R+50)+2])
hold off
subplot(2,1,2);
plot(time_axes,img_psnr,'-*r');  title(' PSNR evolution '); xlabel('time [msec]'); ylabel('');  %xlim([0 time(end)]);

end


%% calculating metrics

avrg_psnr= mean( img_psnr (img_psnr > -inf) );
std_psnr= std( img_psnr (img_psnr > -inf) );
avrg_rate= mean( videoRate);
std_rate= std( videoRate );

nbr_switches=0;
total_lost_pkts=0;

p=decided_Rate_Levels(1);
for i=2:1:l
    if (decided_Rate_Levels(i) ~= p)
        nbr_switches=nbr_switches+1;
        p=decided_Rate_Levels(i);
    end
    
    img=sequence(i);
    
    if get_image(img, 'lost')== inf  
        total_lost_pkts=total_lost_pkts+Dictionary(i, 2);
    else
        total_lost_pkts=total_lost_pkts+get_image(img, 'lost');   
    end
    
end

nbr_lost_imgs = Num_Imgs_ - sum(perfectly_played);

array=[decided_Rate_Levels(1)];
tempo_sizes=[];
for i=2:1:l
    if (array(end) ~= decided_Rate_Levels(i))
        tempo_sizes=[tempo_sizes length(array)];
        array=[decided_Rate_Levels(i)];
    else
        array=[array decided_Rate_Levels(i)];
    end
end
tempo_sizes=[tempo_sizes length(array)];

stableRate_avrgTime_msec=mean(tempo_sizes)*frameDuration_msec;
stableRate_stdTime_msec=std(tempo_sizes)*frameDuration_msec;

%% ploting the CDF of PSNR
count=0;
psnr_axe=[];
count_axe=[];

for x=40:-1:25
    psnr_axe= [psnr_axe x ];
    for i=1:1:l
        if (img_psnr(i) >= x)
            count=count+1;
        end
    end
    count_axe= [count_axe count ];
    count=0;
end

if false
figure,
plot(psnr_axe, count_axe/l, 'r-*' ), set(gca, 'XDir','reverse');
title('');xlabel('psnr'); ylabel('nbr img with psnr > psnr(i) ');
end


%%
%outputYUVfile(perfectly_played, actions_vector, 'past_out_640x360.yuv')

%% dispaly
initial_playBack_delay;
avrg_psnr;
std_psnr;
avrg_rate;
std_rate;
nbr_switches;
nbr_lost_imgs ;
total_lost_pkts;
stableRate_avrgTime_msec;
stableRate_stdTime_msec;

bdw_time=(find(current_R>0)+1);
bdw= current_R(current_R>0);

global Num_Iteration;

 if  rem(Num_Iteration,100)==0
     
str=['plotting_stats_iter_',num2str(Num_Iteration),'.mat'];

save(str, ...
'l',...
'bdw_time',...
'bdw',...
'time',...
'emission_bufferLevel_pckts',...	
'safe_int',...
'img_sizes',...
'perfectly_decoded',...
'pkt_loss',...
'perfectly_played',...
'videoRate',...
'Case',...
'img_psnr',...	
'emiBuffLevel' ,...
'recBuffLevel' ,...
'emiBuffLevelInPkts',... 
'recBuffLevelInPkts' ,...
'psnr_axe',...
'count_axe',...
'initial_playBack_delay',...
'avrg_psnr',...
'std_psnr',...
'avrg_rate',...
'std_rate',...
'nbr_switches',...
'nbr_lost_imgs',...
'total_lost_pkts',...
'not_played_frames',...
'stableRate_avrgTime_msec',...
'stableRate_stdTime_msec');
end

end

