function val = get(a, propName)
% GET Get packet properties from the specified object
% and return the value
switch propName
case 'size'
   val = a.size;
case 'time_idx'
   val = a.time_idx;
case 'layer_idx'
   val = a.layer_idx;
case 'psnr'
   val = a.psnr;
case 'seq_num'
   val = a.seq_num;
case 'seq_num'
   val =a.seq_num;
case 'propag_time'
   val = a.propag_time;
case 'marker'
   val = a.marker;
case 'rate'
   val = a.rate;
otherwise
   error([propName,' Is not a valid packet property'])
end