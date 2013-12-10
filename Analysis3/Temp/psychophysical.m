function [] = psychophysical(block)

cond = block.param.Condition;
condn = height(cond);
cts = block.condtests;
ctsn = height(cts);

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


simpath = '//labsgi1/root/';
econdidx = cts.condidx(efigonts);
efig = cellfun(@(x)imread([simpath,x]),cond.FILENAME,'uniformoutput',false);
eshape = cond{econdidx,'Shape'};
esceneidpos = cond{econdidx,'SceneIDPos'};

figure;
subplot(6,24,1:24);
hist(categorical(econdidx),categorical(1:condn));
set(gca,'xtick',[],'xlim',[0 121]);
for i=1:120
subplot(6,24,24+i);
image(efig{i});
set(gca,'xtick',[],'ytick',[]);
xlabel(num2str(i));
end

figure;
subplot(2,1,1);
hist(categorical(eshape));
subplot(2,1,2)
hist(categorical(esceneidpos));






earlyshapeimage = eshape == 'Image';
earlyshapepatch = eshape == 'Patch';
earlysceneidimage = esceneidpos(earlyshapeimage);
earlysceneidpatch = esceneidpos(earlyshapepatch);
% earlysceneid = cellfun(@(x)regexp(x,'^(.*)x','tokens'),earlysceneid);
% earlysceneid = cellfun(@(x)x(:),earlysceneid);
%earlysceneid = cellfun(@(x,y)[x y],earlysceneid,earlyshape,'uniformoutput',false);


ec = categorical(esceneidpos);
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