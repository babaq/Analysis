function [ pca ] = ParseCAcc( cc,flag,ismerge )
%PARSECACC Parse CellAssemble from ChannelCluster, flag is the same as
%          ParseCAc
import Analysis.Core.* Analysis.Base.*

if nargin==1
    flag = 'each_all';
    ismerge = false;
end
if nargin==2
    ismerge = false;
end

if isnetype(cc,'ChannelCluster')
    pca = CellAssemble(cc.name);
    chn = length(cc.channels);
    cs = [];
    for i = 1:chn
        ca = ParseCAc(cc.channels(i),flag);
        cs = [cs ca.cells];
    end
    if ismerge
        cs = MergeCA(cs);
    end
    pca.cells = cs;
end

end

