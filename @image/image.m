function pic = image(varargin)
%  
% 
switch nargin
case 0 
	pic.size = -1; 
	pic.type = ' ';     %0: I, 1: P, 2: B.
	pic.psnr = -1; 
	
	pic.time_idx = -1; 
	pic.start_encod = -1;  % times
	pic.end_encod= -1;
	pic.end_trans= -1;
	pic.end_decod= -1;
	
	pic.decodable= false;  % true if all pkts arrive all concealment is possible
	pic.lost=0;        
	
	pic = class(pic,'image');
	
case 1
   if (isa(varargin{1},'image'))
	pic = varargin{1}; 
   else  
	pic.size = varargin{1};
	pic.type = ' ';     %0: I, 1: P, 2: B.
	pic.psnr = -1; 
	
	pic.time_idx = -1; 
	pic.start_encod = -1; 
	pic.end_encod= -1;
	pic.end_trans= -1;
	pic.end_decod= -1;
	
	pic.decodable= false; 
	pic.lost=0;        
	
	pic = class(pic,'image');
   end
 case 2
	pic.size = varargin{1};
	pic.type = varargin{2};     %0: I, 1: P, 2: B.
	pic.psnr = -1; 

	pic.time_idx = -1; 
	pic.start_encod = -1; 
	pic.end_encod= -1;
	pic.end_trans= -1;
	pic.end_decod= -1;
	
	pic.decodable= false; 
	pic.lost=0;  
	
	pic = class(pic,'image');
 case 3
	pic.size = varargin{1};
	pic.type = varargin{2};     %0: I, 1: P, 2: B.
	pic.psnr = varargin{3};  

	pic.time_idx = -1; 
	pic.start_encod = -1; 
	pic.end_encod= -1;
	pic.end_trans= -1;
	pic.end_decod= -1;
	
	pic.decodable= false; 
	pic.lost=0;  
	
	pic = class(pic,'image');
otherwise
   error('Wrong number of input arguments')
end