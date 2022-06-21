

function p = packet(varargin)
% PACKET Constructor for Packet class. 
% p = packet(size, time_idx, layer_idx, psnr)
switch nargin
case 0 
   % if no input arguments, create a default object
   p.size = -1;
   p.time_idx = 0;
   p.layer_idx = 0;
   p.psnr = 0;  
   p.seq_num = -1; 
   p.propag_time = -1;      %time until it is considered received 
   p.marker = 0;            %true when RTP pkt is the last of the image
   p.rate = -1;
   p = class(p,'packet');
case 1
   % if single argument of class stock, return it
   if (isa(varargin{1},'packet'))
      p = varargin{1}; 
   else
      p.size = varargin{1};
      p.time_idx = 0;
      p.layer_idx = 0;
      p.psnr = 0;  
      p.seq_num = -1; 
	  p.propag_time = -1;
	  p.marker = 0;
      p.rate = -1;
      p = class(p,'packet');
   end
case 2
   p.size = varargin{1};
   p.time_idx = varargin{2};
   p.layer_idx = 0;
   p.psnr = 0;  
   p.seq_num = -1; 
   p.propag_time = -1;
   p.marker = 0;
   p.rate = -1;
   p = class(p,'packet');
case 3
   p.size = varargin{1};
   p.time_idx = varargin{2};
   p.layer_idx = varargin{3};
   p.psnr = 0; 
   p.seq_num = -1; 
   p.propag_time = -1;
   p.marker = 0;
   p.rate = -1;
   p = class(p,'packet');
case 4
   p.size = varargin{1};
   p.time_idx = varargin{2};
   p.layer_idx = varargin{3};
   p.psnr = varargin{4};  
   p.seq_num = -1; 
   p.propag_time = -1;
   p.marker = 0;
   p.rate = -1;
   p = class(p,'packet');
case 5
   p.size = varargin{1};
   p.time_idx = varargin{2};
   p.layer_idx = varargin{3};
   p.psnr = varargin{4};  
   p.seq_num = varargin{5}; 
   p.propag_time = -1;
   p.marker = 0;
   p.rate = -1;
   p = class(p,'packet');
otherwise
   error('Wrong number of input arguments')
end