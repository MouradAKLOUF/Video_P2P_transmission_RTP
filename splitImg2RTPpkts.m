
function [List_RTP_Pkts, numRTPpkts]=splitImg2RTPpkts(img,maxRTPsize)

%A stupid func that do nothing actually , it suppose to be fragmentation/encapsulation

List_RTP_Pkts=[];
numRTPpkts=0;

while img > maxRTPsize
    List_RTP_Pkts=[List_RTP_Pkts maxRTPsize];
    img=img-maxRTPsize;
    numRTPpkts=numRTPpkts+1;
end

List_RTP_Pkts=[List_RTP_Pkts ceil(img)];
numRTPpkts=numRTPpkts+1;

end