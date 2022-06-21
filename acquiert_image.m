function frame = acquiert_image(time)

% generating a frames  and saving their properties
% this func do nothing for now

%% call global Vars
global frameDuration_msec
global scheduler;

%% update  scheduler
acquiTime=2; %2ms

acq={[time+frameDuration_msec],'acquiert_image'};            %acquiert_image
enc={[time+acquiTime],'encode_image'};                           %encode_image

scheduler = [scheduler; enc; acq];

%%
frame = image(0,0,0); % setting imgSize/type(I,P,B)/PSNR/
  
end

