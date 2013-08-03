function [ pcag ] = ParseCAGccg( ccg,flag,ismerge )
%PARSECAGCCG Parse CellAssemble group from ChannelCluster group, flag is the
%            same as ParseCAc
import Analysis.Base.*

if nargin==1
    flag = 'each_all';
    ismerge = false;
end
if nargin==2
    ismerge = false;
end

for i = 1:length(ccg)
    pcag(i) = ParseCAcc(ccg(i),flag,ismerge);
end

end

