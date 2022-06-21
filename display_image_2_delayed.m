function display_image_2_delayed(time)

% display img 
% this function do nothing currently 

%% call global Vars
global frameDuration_msec
global scheduler;
global TS_d;
global TS_r;
global TS;
global dt;
global Num_Played_Imgs_;
global Num_Imgs_;
global decoded_new_img;
global rewards;

global emission;
global reception;

global not_played_frames;

%% update  scheduler

dis={[time+frameDuration_msec],'display_image'};              %display_image
scheduler = [scheduler; dis];

if Num_Played_Imgs_ >= Num_Imgs_
    reception = clear_buffer(reception) ; 
    return;
end

%%

TS_d=TS_d+dt;  
Num_Played_Imgs_=int16(TS_d/dt)+1;   

if TS_r <= TS_d                                               % if it's time to display TS_d img, forgett about the others and try to decod TS_d+1
    decoded_new_img=true;
    TS_r = TS_d;
end

%%

%%
bitsToSend=get_buffer(emission, 'bits_to_send');
p=getAllPackets(emission);
emission = clear_buffer(emission) ;                    
temp_p=[];
for k=1:1:length(p)
    r=p(k);
    if get(r, 'time_idx')> TS_d
       temp_p=[temp_p r]; 
    end
end
p=temp_p;
for k=1:1:length(p)
   emission = insert(emission, p(k) );
end
emission = change_bitToSend(emission,bitsToSend);

%%


%%

global decided_Rate_Levels;
global perfectly_played;
global img_psnr;
global safe_int;
global videoRate;
global sequence;
global actions_vector;
global Dictionary;
global tracing_imgs;
global rewards_Levels;

img_indx=int16(TS_d/dt)+1;

if img_indx==1
        imgType='I';
else
    if  (img_indx /32) > 1 &&  (rem(img_indx,32)>=1   && rem(img_indx,32)<=10 )
        imgType='P_intraRefresh';
    else
        imgType='P_normal';
    end
end

img=sequence(int16(TS_d/dt)+1);
diff=time - get_image(img, 'end_decod') ;

   if  (get_image(img, 'decodable') == 1 && diff>= 0 )
      
      perfectly_played(int16(TS_d/dt)+1)=1;
      
      if int16(TS_d/dt)+1 > 1
            img_psnr(int16(TS_d/dt)+1)= img_psnr(int16(TS_d/dt))+5;
              if  img_psnr(int16(TS_d/dt)+1) >  get_image(img, 'psnr')                                                           %get_image(img, 'psnr')
              img_psnr(int16(TS_d/dt)+1)= get_image(img, 'psnr')  ;
              end

      else
          img_psnr(int16(TS_d/dt)+1)= get_image(img, 'psnr');
      end
      
      rewards= [rewards  img_psnr(int16(TS_d/dt)+1)];
      videoRate(int16(TS_d/dt)+1)=decided_Rate_Levels(int16(TS_d/dt)+1);
      safe_int(int16(TS_d/dt)+1)= diff;
      
      if  int16(TS_d/dt)+1 > 1 && int16(TS_d/dt)+1 < Num_Imgs_
      %update_Q_function(int16(TS_d/dt)+1, img_psnr(int16(TS_d/dt)+1), imgType);
      %update_Q_function_NstepSARSA(int16(TS_d/dt)+1, img_psnr(int16(TS_d/dt)+1));
      end
      
   else
      perfectly_played(int16(TS_d/dt)+1)=0;
      not_played_frames(int16(TS_d/dt)+1)=decided_Rate_Levels(int16(TS_d/dt)+1);
      
      temp= find (perfectly_played>0);  %

      if length (temp) == 0
          
          img_psnr(int16(TS_d/dt)+1)= 0;
          videoRate(int16(TS_d/dt)+1)=decided_Rate_Levels(int16(TS_d/dt)+1);
          safe_int(int16(TS_d/dt)+1)=  -1;
          rewards= [rewards  img_psnr(int16(TS_d/dt)+1)];
      
          if  int16(TS_d/dt)+1 > 1 && int16(TS_d/dt)+1 < Num_Imgs_
          %update_Q_function(int16(TS_d/dt)+1, 0, imgType);
          %update_Q_function_NstepSARSA(int16(TS_d/dt)+1, 0);
          end
          
      return;
      end
      
      
      img_psnr(int16(TS_d/dt)+1)= img_psnr(int16(TS_d/dt)) - 5;
%       if img_psnr(int16(TS_d/dt)+1) <0
%           img_psnr(int16(TS_d/dt)+1)=0;
%       end
            
      rewards= [rewards  img_psnr(int16(TS_d/dt)+1)];
      videoRate(int16(TS_d/dt)+1)=decided_Rate_Levels(int16(TS_d/dt)+1);
      safe_int(int16(TS_d/dt)+1)=  -1;    
      
      if  int16(TS_d/dt)+1 > 1 && int16(TS_d/dt)+1 < Num_Imgs_
       %update_Q_function(int16(TS_d/dt)+1, img_psnr(int16(TS_d/dt)+1), imgType);
       %update_Q_function_NstepSARSA(int16(TS_d/dt)+1, img_psnr(int16(TS_d/dt)+1));
      end
      
   end


 end
