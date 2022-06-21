function a = set(a,varargin)

% SET Set packet properties and return the updated object
propertyArgIn = varargin;

while length(propertyArgIn) >= 2,
   prop = propertyArgIn{1};
   val = propertyArgIn{2};
   propertyArgIn = propertyArgIn(3:end);
   switch prop
   case 'size'
      a.size = val;
   case 'time_idx'
      a.time_idx = val;
   case 'layer_idx'
      a.layer_idx = val;
   case 'psnr'
      a.psnr = val;
   case 'seq_num'
      a.seq_num = val;
   case 'propag_time'
      a.propag_time = val;
   case 'marker'
      a.marker = val;
   case 'rate'
      a.rate = val;
   otherwise
      error('Packet properties: size, time_idx, layer_idx, psnr, seq_num, propag_time,marker,rate')
   end
   
end