function display(a)
% DISPLAY(a) Display an packet object
stg = sprintf(...
   'Size: %d\n	time_idx: %d\n	Layer_index: %d\n	PSNR:%9.2f\n	seq_num: %d\n	propag_time: %d\n  marker: %d\n',...
   a.size,a.time_idx,a.layer_idx,a.psnr,a.seq_num,a.propag_time, a.marker);
disp(stg)

