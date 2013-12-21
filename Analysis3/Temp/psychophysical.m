function [] = psychophysical(block)

cond = block.param.Condition;
condn = height(cond);
cts = block.data.condtests;
ctsn = height(cts);
simpath = '//labsgi1/root/';
condfig = cellfun(@(x)imread([simpath,x]),cond.FILENAME,'uniformoutput',false);
condor3 = cellfun(@(x)str2double(x),cond.OR3);
condsceneidpos = categorical(cond.SceneIDPos);
csidp = categories(condsceneidpos);
csidpn = length(csidp);
condshape = categorical(cond.Shape);
cshape = categories(condshape);
cshapen = length(cshape);

earlyts = cts.status=='Early';
figonts = cellfun(@(x)~isempty(x),cts.figontime);
figontsn = nnz(figonts);
figoffts = cellfun(@(x)~isempty(x),cts.figofftime);
efigonts = earlyts & figonts;
efigontsn = nnz(efigonts);
efigoffts = earlyts & figoffts;
issamects = length(find(efigonts == efigoffts))==height(cts);
disp([num2str(figontsn),' FIG ON Test in total of ',num2str(ctsn),' Test(',num2str(figontsn/ctsn*100),'%)']);
disp([num2str(efigontsn),' Early Test in total of ',num2str(figontsn),' FIG Test(',num2str(efigontsn/figontsn*100),'%)']);
t1 = cts(efigonts,{'condtestdur','figontime'});
t1.figontime = cell2mat(t1.figontime);
t2 = cts(efigoffts,{'condtestdur','figofftime'});
t2.figofftime = cell2mat(t2.figofftime);
e2figon = t1.condtestdur - t1.figontime;
e2figoff = t2.condtestdur - t2.figofftime;

figure;
bins = 0:20:floor(max(e2figon)*1.1);
if ~issamects
    hist([e2figon e2figoff],bins);
else
    subplot(2,1,1);
    hist(e2figon,bins);
    subplot(2,1,2);
    hist(e2figoff,bins);
end


econdidx = cts.condidx(efigonts);

figure;
vsidp = condn/csidpn;
subplot(1+csidpn,vsidp,1:vsidp);
hist(categorical(econdidx),categorical(1:condn));
set(gca,'xtick',[],'xlim',[0 condn+1]);
for i=1:condn
subplot(1+csidpn,vsidp,vsidp+i);
image(imrotate(condfig{i},condor3(i)));
set(gca,'xtick',[],'ytick',[]);
xlabel(num2str(i));
end

eor3 = condor3(econdidx);
eshape = condshape(econdidx);
esidp = condsceneidpos(econdidx);

figure;
subplot(2,1,1);
[n1 x]=hist(eshape(eor3==0),cshape);
[n2 x]=hist(eshape(eor3==180),cshape);
bar(1:cshapen,[n1; n2]',1);
set(gca,'xticklabel',x);
subplot(2,1,2);
hist(esidp,csidp);





% earlysceneid = cellfun(@(x)regexp(x,'^(.*)x','tokens'),earlysceneid);
% earlysceneid = cellfun(@(x)x(:),earlysceneid);
%earlysceneid = cellfun(@(x,y)[x y],earlysceneid,earlyshape,'uniformoutput',false);





% sceneid = cellfun(@(x)regexp(x,'^(.*)x','tokens'),sceneid);
% sceneid = cellfun(@(x)x(:),sceneid);




end