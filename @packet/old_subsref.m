function b = subsref(a,index)
%SUBSREF Define field name indexing for packet objects
switch index.type
case '()'
   switch index.subs{:}
   case 1
      b = a.size;
   case 2
      b = a.time_idx;
   case 3
      b = a.layer_idx;
   case 4
      b = a.psnr;
   case 5
      b = a.seq_num;
   case 6
	  b = a.propag_time;
   case 7
	  b = a.marker;
   otherwise
      error('Index out of range')
   end
   
case '.'
   switch index.subs
   case 'size'
      b = a.size;
   case 'time_idx'
      b = a.time_idx;
   case 'layer_idx'
      b = a.layer_idx;
   case 'psnr'
      b = a.psnr;
   case 'seq_num'
      b = a.seq_num;
   case 'propag_time'
	  b = a.propag_time;
   case 'marker'
	  b = a.marker;
   otherwise
      error('Invalid field name')
   end
   
case '{}'
   error('Cell array indexing not supported by asset objects')
end