function pic = set_image(pic,varargin)
% 
%
propertyArgIn = varargin;
while length(propertyArgIn) >= 2,
   prop = propertyArgIn{1};
   val = propertyArgIn{2};
   propertyArgIn = propertyArgIn(3:end);
   switch prop
   case 'size'
      pic.size = val;
   case 'type'
      pic.type = val;
   case 'psnr'
      pic.psnr = val;

	case 'time_idx'
      pic.time_idx = val; 
	case 'start_encod'
      pic.start_encod = val;
	case 'end_encod'
      pic.end_encod = val;
	case 'end_trans'
      pic.end_trans = val;
	case 'end_decod'
      pic.end_decod = val;
	  
	case 'decodable'
      pic.decodable = val;
	case 'lost'
      pic.lost = val;
	  
   otherwise
      error('img properties incorrect')
   end
end
