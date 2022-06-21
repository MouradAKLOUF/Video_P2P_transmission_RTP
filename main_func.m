
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   About:
%   Scheduler for video frames transmission over RTP/UDP network, 
%   encoding rate decision is made using a timebased Algo - the baseline Algo-
%
%   EKTACOM, Les Ulis, France.
%   Laboratoire des Signaux et Systèmes, CentraleSupélec, France.
%   Author: Mourad AKLOUF, email:  mourad.aklouf@l2s.centralesupelec.fr/maklouf@ektacom.com
%   Date: May 28th, 2020
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc, clear, close all,

%% Global variables 
global frameDuration_msec;
global IntraRefresh_frameSizes;
global IntraRefresh_avrgPSNR;
global R;
global current_R;
global pred_R;
global Num_Imgs_;
global Num_Encoded_Imgs_;
global Num_Decoded_Imgs_;
global Num_Played_Imgs_;
global dt;
global TS;
global TS_r;
global TS_d;
global initial_playBack_delay;
global sequence;
global Dictionary;
global emission;
global reception;
global scheduler;
global fisrt_call_off_transmit_packet;
global pkts_waiting_
global decoded_new_img;
global last_send_time;
global vidLevels;
global maxRTPsize;
global actions_vector;
global decided_Rate_Levels;
global emission_bufferLevel_pckts;
global reception_bufferLevel_pckts;
global emission_bufferLevel_bits;
global reception_bufferLevel_bits;
global T;
global buff_max_size;

global encoding_time_I;
global encoding_time_P; 
global decoding_time_I;
global decoding_time_P; 

global perfectly_played;
global img_psnr;
global safe_int;
global videoRate;

global recBuffLevel,
global emiBuffLevel,

global recBuffLevelInPkts,
global emiBuffLevelInPkts,

global num_pkts;
global tracing_MDP;
global not_played_frames;


%% Global Config
%GOP config
fps=25;
frameDuration_msec=floor((1/fps)*1000);

vidLevels=[50,200,400,600,800,1000,1200];

load('IntraRefresh_data.mat');    
load('bandwidth_1msInterp.mat'); 

%Num_Imgs_= length(IntraRefresh_avrgPSNR{1});    % it will be used to initialize containers.
Num_Imgs_= 600;

initial_playBack_delay =100*frameDuration_msec;      %how much time the rec player will wait before start playing. It is used also as time before considering the pckt lost 
                                                                           %-- >this is static : = time between acquisition & playing 1st image e.g. = 120msec 
T=(Num_Imgs_*frameDuration_msec);                  % simul duration
T=T+2*initial_playBack_delay;

% time config
clock=90;                                                             %dt=3.00 for 90kHz  
dt=clock/fps;                                                        %delta_Timestamp
                                                                       
% channel characteristics/mesurements
PER= 0.05;
drop_pkts=false;
% buff config
maxRTPsize =899;

% codec caract
encoding_time_I=20;
encoding_time_P=20; 
decoding_time_I=20;
decoding_time_P=20;

%% MDP init

global num_channel_states;
global rewards;
global Num_Iteration;                                            % this is the idx of the episode
global tracing_imgs;
global R_intervals;

%%

one_cycle=B2(7798:125100);
cycle_len=length(one_cycle);

num_cycles= ceil(T/length(one_cycle));

%%

global num_episodes;
num_episodes=2;


buff_max_size=500;                                               %max num of pckts in buffers

%%

global TxRx_delay_imgs;
TxRx_delay_imgs=-1*ones(Num_Imgs_ ,1);


starting_points=-1*ones(1 ,num_episodes); 

for it=1:1:num_episodes
  
% start_point= randi([1,length(one_cycle)],1,1);   %incase you want new bdwth trace in each new episode 
% R=[one_cycle(start_point:end)];
% for i=1:num_cycles
%     R=[R one_cycle];
% end
% R=[R one_cycle];
% starting_points(1 ,it)=start_point; 

R=[one_cycle(16644:end) one_cycle];  %incase you want same bdwth trace in all episodes 

%R=1200*ones(1,T);  %incase you want same bdwth trace in all episodes 


%%
% epis indx    
Num_Iteration=it;
%
Num_Encoded_Imgs_=0;                                       % used as indx
Num_Decoded_Imgs_=0;                                       % used as indx
Num_Played_Imgs_=0;                                          % used as indx
TS=-dt;                                                               %Timestamp at sender
TS_r=-dt;                                                            %Timestamp at receiver
TS_d=-dt;                                                            %Timestamp at disp
sequence=[];                                                       % append it with frames each time you encod one
% buff config
emission = packet_buffer(buff_max_size);
reception = packet_buffer(buff_max_size);

fisrt_call_off_transmit_packet= true;

pkts_waiting_=[];                                                  % internal buff to save pkts with high propagation delay untill it's time to arrive
decoded_new_img=true;
last_send_time=0;
% saving infos about the generated images
Dictionary=zeros(Num_Imgs_ ,2);                          % for each img you will have a TS and numb of RTP pkts, 

emission_bufferLevel_pckts= zeros(floor(T/2),1);
reception_bufferLevel_pckts= zeros(floor(T/2),1);
emission_bufferLevel_bits= zeros(floor(T/2),1);
reception_bufferLevel_bits= zeros(floor(T/2),1);

current_R= zeros(T,1);
pred_R= zeros(T,1);

actions_vector=zeros(Num_Imgs_ ,1);
decided_Rate_Levels=zeros(Num_Imgs_ ,1);

perfectly_played=zeros(Num_Imgs_ ,1);
img_psnr=-inf*ones(Num_Imgs_ ,1);
safe_int=zeros(Num_Imgs_ ,1);
videoRate=zeros(Num_Imgs_ ,1);
not_played_frames=-50*ones(Num_Imgs_ ,1);

global received_flag;
global num_received_pkts;
received_flag =zeros(Num_Imgs_ ,1);
num_received_pkts =zeros(Num_Imgs_ ,1);

recBuffLevel=zeros(Num_Imgs_ ,1);
emiBuffLevel=zeros(Num_Imgs_ ,1);
recBuffLevelInPkts=zeros(Num_Imgs_ ,1);
emiBuffLevelInPkts=zeros(Num_Imgs_ ,1);

%rewards=zeros(Num_Imgs_ ,1);
rewards=[0];
tracing_imgs=zeros(Num_Imgs_ ,4);

%% scheduler  initialization
stats = {[0],'get_stats'};                                        % gest stats each 2msec, you can change this freq inide the function

acq = {[0],'acquiert_image'};
dis = {[initial_playBack_delay],'display_image'};
tra = {[2],'transmit_packet'};                                 % strat transmitting ASAP, doesn't matter if emiss_buff is empty 

scheduler = [stats;acq;dis;tra];
%%  main loop
global num_imgs;
emission = clear_buffer(emission) ;   

break_loop = false;

for horloge = 0:T
    i=1;
    l=size(scheduler);
    while  i<=l(1) 
        if scheduler{i,1} <= horloge
            if strcmp(scheduler{i,2},'acquiert_image')
                scheduler(i,:)=[];
                img = acquiert_image(horloge);
                i=i-1;l=size(scheduler);
            elseif strcmp(scheduler{i,2},'encode_image')
                scheduler(i,:)=[];
                RTP_packets = encode_image(horloge,img); 
                i=i-1;l=size(scheduler);
            elseif strcmp(scheduler{i,2},'fill_emission_buffer')
                scheduler(i,:)=[];
                fill_emission_buffer(horloge,RTP_packets);  
                i=i-1;l=size(scheduler);
            elseif strcmp(scheduler{i,2},'transmit_packet')
                scheduler(i,:)=[];
                transmit_packet_2(horloge,drop_pkts,PER);
                i=i-1;l=size(scheduler);
            elseif strcmp(scheduler{i,2},'display_image')
                scheduler(i,:)=[];
                display_image_2_delayed(horloge);
                i=i-1;l=size(scheduler);
            elseif strcmp(scheduler{i,2},'get_stats')
                scheduler(i,:)=[];
                get_stats(horloge);
                i=i-1;l=size(scheduler);
            end
        end
        i=i+1;
    end
    
    horloge;                                                 %display time
    scheduler;                                                 %display the scheduling
    
    Num_Encoded_Imgs_;
	Num_Decoded_Imgs_;
	Num_Played_Imgs_;
    num_imgs;

end

%% plot and print stats
[avrg_psnr, std_psnr, avrg_rate,  std_rate, nbr_switches, nbr_lost_imgs,  total_lost_pkts, stableRate_avrgTime_msec, stableRate_stdTime_msec]= plot_and_print_stats ();
epis_saves(: ,it)= [avrg_psnr, std_psnr, avrg_rate,  std_rate, nbr_switches, nbr_lost_imgs,  total_lost_pkts, stableRate_avrgTime_msec, stableRate_stdTime_msec];


end

%% dispaly performances

figure,
avrg_psnr_epis=epis_saves(1 ,:);
subplot(3,2,1); plot(avrg_psnr_epis);   title('avrg psnr per episode','FontSize',14);xlabel('number of iteration','FontSize',14); ylabel('');
avrg_rates_epis=epis_saves(3 ,:);
subplot(3,2,2);plot(avrg_rates_epis);  title('avrg rate per episode','FontSize',14);xlabel('number of iteration','FontSize',14); ylabel('');
nbr_switches_epis=epis_saves(5 ,:);
subplot(3,2,3);plot(nbr_switches_epis);  title('nbr rate switches per episode','FontSize',14);xlabel('number of iteration','FontSize',14); ylabel('');
nbr_lost_imgs_epis=epis_saves(6 ,:);
subplot(3,2,4);plot(nbr_lost_imgs_epis);  title('nbr lost imgs per episode','FontSize',14);xlabel('number of iteration','FontSize',14); ylabel('');
nbr_lost_pkts_epis=epis_saves(7 ,:);
subplot(3,2,5);plot(nbr_lost_pkts_epis);    title('nbr lost pkts per episode','FontSize',14);xlabel('number of iteration','FontSize',14); ylabel('');
%saveas(figure3,'episodic_saves.png')

%%
%close all


figure,
plot(TxRx_delay_imgs,'-*b')
title(' full delay (trans - decod), encoding Rate = 1000Kbps ');xlabel('Frame indx'); ylabel('delay [msec]');

  

figure,
time_axes=2:Num_Imgs_;
subplot(2,1,1); plot(time_axes,current_R(current_R>0),'*-b');    title('Transmission Rate');xlabel('Frame indx'); ylabel('[Kbps]'); 
hold on
plot(time_axes,600,'*-r'); 
hold off
grid,  set(gca,'FontSize',12), legend('Transmission Rate','Encoding Rate')

time_axes=1:Num_Imgs_;
subplot(2,1,2); plot(time_axes,TxRx_delay_imgs,'*-r');   title('End-To-End Delay ');xlabel('Frame indx'); ylabel('[ms]');          
grid,  set(gca,'FontSize',12), , legend('End-To-End Delay')


