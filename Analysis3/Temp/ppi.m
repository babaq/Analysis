cond = block.param.Condition;
ct = block.condtests;


earlys = ct.status==1;
earlycond = ct.item(earlys);
figure;
hist(categorical(earlycond));
earlysceneid = cond{earlycond,'SceneIDPos'};
earlyshape = cond{earlycond,'Shape'};
earlyshape = categorical(earlyshape);
earlyshapeimage = earlyshape == 'Image';
earlyshapepatch = earlyshape == 'Patch';
earlysceneidimage = earlysceneid(earlyshapeimage);
earlysceneidpatch = earlysceneid(earlyshapepatch);
% earlysceneid = cellfun(@(x)regexp(x,'^(.*)x','tokens'),earlysceneid);
% earlysceneid = cellfun(@(x)x(:),earlysceneid);
%earlysceneid = cellfun(@(x,y)[x y],earlysceneid,earlyshape,'uniformoutput',false);


ec = categorical(earlysceneid);
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
