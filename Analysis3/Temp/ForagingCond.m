function [ fp,dots,dotrfidx,dotfigtype ] = ForagingCond( rfpos,or,isdprand,isalternaterevcol,dprepn,...
    dotfigtypep,maxfl,origin,rewardfigtype,rewardfigtypep,rewardfigtypen,dpn,filepath )
%FORAGINGCOND Summary of this function goes here
%   Detailed explanation goes here

import Analysis.Base.*

rfd = sqrt(sum(rfpos.^2));
pushscale = 0;
fpir = 0.01;
figtypen = length(dotfigtypep);
rewardfigtypen = 1;
if isdprand
    dprandr = 0.2;
else
    dprandr = 0.00001;
end
% [ dots,dotrfidx ] = RFPattern1_1( rfpos,isdprand,dprepn );
% [ dots,dotrfidx ] = RFPattern1_2( rfpos,isdprand );
dn = 10;
origin = arraypending(origin,figtypen,1);
israndrewardfigtype = length(rewardfigtype)>1;
randrewardfigtypeidx = drv(rewardfigtypep,dpn,true);

    function dps = getdp(dpnum,ori)
        for di=1:dpnum
            %     dotfigtype = Analysis.Base.drv(dotfigtypep,dn);
            dotfigtype = Analysis.Base.drv(dotfigtypep,dn,true);
            [ dots,dotrfidx ] = RFPattern1_3( rfpos,ori,origin,dotfigtype );
            [ fp,dots ] = randtransDP( dots,fpir,60, pushscale,dprandr );
            %     plotDP(dots);
            
            if israndrewardfigtype
                crewardfigtype = rewardfigtype(randrewardfigtypeidx(di));
            else
                crewardfigtype = rewardfigtype;
            end
            rfigidx = rewardfig(dotfigtype,crewardfigtype,rewardfigtypen);
            for i=1:dn
                s{i,1} = ['POSX_',num2str(i),' ',num2str(dots(i,1))];
                s{i,2} = ['POSY_',num2str(i),' ',num2str(dots(i,2))];
                s{i,3} = ['PRFIDX_',num2str(i),' ',num2str(dotrfidx(i))];
                s{i,4} = ['PFIGTYPE_',num2str(i),' ',num2str(dotfigtype(i)-1)];
            end
            
            ss = reshape(s,1,[]);
            ss = [{['FPOSH',' ',num2str(fp(1)),', ','FPOSV',' ',num2str(fp(2))]} ss];
            ss{1,end+1} = ['REWARDTYPE',' ',num2str(crewardfigtype-1)];
            ss{1,end+1} = ['REWARDIDX',' ',num2str(find(rfigidx == 1))];
            dps{di,1} = ss{1};
            for i=2:length(ss)
                dps{di,1} = [dps{di,1},', ',ss{i}];
            end
        end
    end

% orientation( figure side flip )
cor0 = getdp(dpn,or);
cor1 = getdp(dpn,mod(or+180,360));
o0 = arraypending({[', FT0OR',' ',num2str(or),', ','FT1OR',' ',num2str(or)]},dpn,1);
o1 = arraypending({[', FT0OR',' ',num2str(mod(or+180,360)),', ','FT1OR',' ',num2str(mod(or+180,360))]},dpn,1);
co0 = cellfun(@(x,y)cat(2,x,y),cor0,o0,'uniformoutput',false);
co1 = cellfun(@(x,y)cat(2,x,y),cor1,o1,'uniformoutput',false);
c = [co0;co1];
% revert figure/background color
condn = size(c,1);
if isalternaterevcol
    rcs1 = {', REVCOL 0';', REVCOL 1'};
    rccs1 = repmat(rcs1,condn/2,1);
    rcs2 = {', REVCOL 1';', REVCOL 0'};
    rccs2 = repmat(rcs2,condn/2,1);
    dc = repmat(c,2,1);
    c = cellfun(@(x,y)cat(2,x,y),dc,[rccs1;rccs2],'uniformoutput',false);
    t = c(condn+1);
    c(condn+1)=[];
    c=[c;t];
else
    rev0 = arraypending({', REVCOL 0'},condn,1);
    rev1 = arraypending({', REVCOL 1'},condn,1);
    cr0 = cellfun(@(x,y)cat(2,x,y),c,rev0,'uniformoutput',false);
    cr1 = cellfun(@(x,y)cat(2,x,y),c,rev1,'uniformoutput',false);
    c = [cr0;cr1];
end
% set mask orientation
condn = size(c,1);
mo1 = {[', MASKOR ',num2str(mod(or+90,360))];[', MASKOR ',num2str(mod(or+270,360))]};
mos1 = repmat(mo1,condn/2,1);
mo2 = {[', MASKOR ',num2str(mod(or+270,360))];[', MASKOR ',num2str(mod(or+90,360))]};
mos2 = repmat(mo2,condn/2,1);
dc = repmat(c,2,1);
c = cellfun(@(x,y)cat(2,x,y),dc,[mos1;mos2],'uniformoutput',false);
t = c(condn+1);
c(condn+1)=[];
c=[c;t];
% random orientation
% ro = randi([0,359],condn,1);
% randori = arrayfun(@(x)[', MASKOR ',num2str(x)],ro,'uniformoutput',false);
% c = cellfun(@(x,y)cat(2,x,y),c,randori,'uniformoutput',false);

% get mask square grating temporal freqency and cycle width
dt = 0.2;
wrange=2.5*maxfl:6:5*rfd;
frange = 0.5:0.01:(0.5/dt);
tf = @(c)(c-2*maxfl)./(2*dt*c);
cw = @(f)maxfl./(0.5-dt*f);

f = tf(wrange);
vfi = (f>frange(1)) & (f<frange(end));
f=f(vfi);
w=wrange(vfi);
[m,midwi]=min(abs(w-(w(end)-w(1))/2-w(1)));
w1 = w(midwi);
f1 = f(midwi);

w = cw(frange);
vwi = (w>wrange(1)) & (w<wrange(end));
w = w(vwi);
f = frange(vwi);
[m,midfi]=min(abs(f-(f(end)-f(1))/2-f(1)));
f2 = f(midfi);
w2 = w(midfi);

condn = size(c,1);
w3 = (w1-w2)/2+w2;
wlow = w3-(w1-w2)/4;
whigh = w3+(w1-w2)/4;
ws = round(rand(condn,1)*(whigh-wlow)+wlow);
fs = floor(tf(ws)*100)/100;
wfs = arrayfun(@(x,y)[', GRCYCLEWID ',num2str(x),', GRDRIFTFREQ ',num2str(y)],ws,fs,'uniformoutput',false);
c = cellfun(@(x,y)cat(2,x,y),c,wfs,'uniformoutput',false);

% write condition file
rf = ['_rf=(',num2str(rfpos(1)),',',num2str(rfpos(2)),')'];
if isdprand
    rf = [rf,'_dpr'];
end
if isalternaterevcol
    rf = [rf,'_rca'];
end
ori = ['_or=',num2str(or)];
if nnz(origin)>0
    os = '_origin=edge';
else
    os = '_origin=center';
end
ftp = ['_ftp=(',regexprep(num2str(dotfigtypep),'\s*',','),')'];
rft = ['_rft=(',regexprep(num2str(rewardfigtype),'\s*',','),')'];
rftp = ['_rftp=(',regexprep(num2str(rewardfigtypep),'\s*',','),')'];

condn = size(c,1);
ns = ['_',num2str(dpn),'-',num2str(condn)];
cfile = ['Foraging_',num2str(dn),rf,ori,os,ftp,rft,rftp,ns,'.vlc'];
fid = fopen(fullfile(filepath,cfile),'w');
for ci=1:condn
    fprintf(fid,'%s\r\n',c{ci,1});
end
fclose(fid);

end