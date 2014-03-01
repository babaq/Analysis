function [ fp,dots,dotrfidx,dotfig,rfigidx ] = ForagingCond( rfpos,israndom,repn,p,cn,rootpath )
%FORAGINGCOND Summary of this function goes here
%   Detailed explanation goes here

FigType = {'Distractor','Target'};

for cidx=1:cn
    [ dots,dotrfidx ] = RFPattern1_1( rfpos,israndom,repn );
    [ fp,dots ] = randtransDP( dots,0.5,0.1 );
    %plotDP(dots);
    dn = length(dotrfidx);
    dotfig = Analysis.Base.drv(p,dn);
    rfigidx = rewardfig(dotfig,2,1);
    for i=1:dn
        s{i,1} = ['POSX_',num2str(i),' ',num2str(dots(i,1))];
        s{i,2} = ['POSY_',num2str(i),' ',num2str(dots(i,2))];
        s{i,3} = ['PRFIDX_',num2str(i),' ',num2str(dotrfidx(i))];
        s{i,4} = ['PFIGTYPE_',num2str(i),' ',num2str(dotfig(i)-1)];
    end
    
    ss = reshape(s,1,[]);
    ss = [{['FPOSH',' ',num2str(fp(1)),', ','FPOSV',' ',num2str(fp(2))]} ss];
    ss{1,end+1} = ['REWARDIDX',' ',num2str(find(rfigidx == 1))];
    c{cidx,1} = ss{1};
    for i=2:length(ss)
        c{cidx,1} = [c{cidx,1},', ',ss{i}];
    end
    
end

isr='';
if israndom
    isr = '_randpos';
end
tp = ['_tp',num2str(p(2))];

cfile = ['Foraging',isr,'_',num2str(dn),tp,'_',num2str(cn),'.vlc'];
fid = fopen(fullfile(rootpath,cfile),'w');
for cidx=1:cn
    fprintf(fid,'%s\r\n',c{cidx,1});
end
fclose(fid);

end