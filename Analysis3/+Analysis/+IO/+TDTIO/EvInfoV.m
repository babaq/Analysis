function [ eiv ] = EvInfoV( TTX,eivr )
%EVINFOV parse ParseEvInfoV results
%input:
%    eivr   single EvInfoV result using 0 to return all items in ParseEvInfoV
import Analysis.IO.TDTIO.TTank.*

eiv.waveinbytes = eivr(1);
eiv.evtype = EvTypeToString(TTX,eivr(2));
eiv.evcode = CodeToString(TTX,eivr(3));
eiv.chn = eivr(4);
eiv.sortn = eivr(5);
eiv.time = eivr(6);
eiv.value = eivr(7);
eiv.dformat = DFromToString(TTX,eivr(8));
eiv.wavefs = eivr(9);

end

