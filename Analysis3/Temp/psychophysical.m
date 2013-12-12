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
figoffts = cellfun(@(x)~isempty(x),cts.figofftime);
efigonts = earlyts & figonts;
efigoffts = earlyts & figoffts;
issamects = length(find(efigonts == efigoffts))==height(cts);
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
eshape = cond{econdidx,'Shape'};
esidp = cond{econdidx,'SceneIDPos'};

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

figure;
subplot(2,1,1);
hist(categorical(eshape),cshape);
subplot(2,1,2)
hist(categorical(esidp),csidp);






earlyshapeimage = eshape == 'Image';
earlyshapepatch = eshape == 'Patch';
earlysceneidimage = esidp(earlyshapeimage);
earlysceneidpatch = esidp(earlyshapepatch);
% earlysceneid = cellfun(@(x)regexp(x,'^(.*)x','tokens'),earlysceneid);
% earlysceneid = cellfun(@(x)x(:),earlysceneid);
%earlysceneid = cellfun(@(x,y)[x y],earlysceneid,earlyshape,'uniformoutput',false);


ec = categorical(esidp);
ecn = length(categories(ec));

eci = categorical(earlysceneidimage);
ecn = length(categories(eci));

figure;
hist(eci);


sceneid = cond{:,'SceneIDPos'};
shape = cond{:,'Shape'};
% sceneid = cellfun(@(x)regexp(x,'^(.*)x','tokens'),sceneid);
% sceneid = cellfun(@(x)x(:),sceneid);
sceneid = cellfun(@(x,y){[x y]},sceneid,shape);
sc = categorical(sceneid);
sc = categories(sc);
scn = length(sc);

disp([num2str(ecn),' of ',num2str(scn),' scenes caused fixation break ',num2str(ecn/scn*100),' %']);


figure;
hist(ec);
end