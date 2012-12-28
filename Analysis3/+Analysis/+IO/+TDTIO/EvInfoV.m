function [ eiv ] = EvInfoV( TX,eivr )
%EVINFOV parse ParseEvInfoV results
%input:
%    eivr   single EvInfoV result using 0 to return all items in ParseEvInfoV
import Analysis.IO.TDTIO.TTankX.*

eiv.waveinbytes = eivr(1);
eiv.evtype = EvTypeToString(TX,eivr(2));
eiv.evcode = CodeToString(TX,eivr(3));
eiv.chn = eivr(4);
eiv.sortn = eivr(5);
eiv.time = eivr(6);
eiv.value = eivr(7);
eiv.dformat = DFromToString(TX,eivr(8));
eiv.wavefs = eivr(9);

end

