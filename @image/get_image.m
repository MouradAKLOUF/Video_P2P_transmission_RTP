function val = get_image(pic, propName)

switch propName
case 'size'
   val = pic.size;
case 'type'
   val = pic.type;
case 'psnr'
   val = pic.psnr;

case 'time_idx'
  val = pic.time_idx;  
case 'start_encod'
  val = pic.start_encod;
case 'end_encod'
  val = pic.end_encod;
case 'end_trans'
  val = pic.end_trans;
case 'end_decod'
  val = pic.end_decod;
  
case 'decodable'
  val = pic.decodable;
case 'lost'
  val = pic.lost;

otherwise
   error([propName,' Is not a valid packet property'])
end