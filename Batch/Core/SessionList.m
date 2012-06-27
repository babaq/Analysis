function Sessions = SessionList(Experiment)
% SessionList.m %
% 2011-04-03 Zhang Li
% Generate Session List from Experiment

session = cell(1,3);
Sessions=[];
for s=1:size(Experiment.Subjects,1)
    for p=1:size(Experiment.Subjects{s,1}.Penetrations,1)
        for r = 1:size(Experiment.Subjects{s,1}.Penetrations{p,1}.Sites,1)
            session{1,1}=Experiment.Subjects{s,1}.Name;
            session{1,2}=Experiment.Subjects{s,1}.DataSet;
            session{1,3}.session=['(',Experiment.Subjects{s,1}.Penetrations{p,1}.Region,num2str(p),'_',num2str(r),')'];
            session{1,3}.site=Experiment.Subjects{s,1}.Penetrations{p,1}.Sites(r,1);
            session{1,3}.coordinate = Experiment.Subjects{s,1}.Penetrations{p,1}.Coordinate;
            session{1,3}.eccentricity = Experiment.Subjects{s,1}.Penetrations{p,1}.Eccentricity;
            Sessions = cat(1,Sessions,session);
        end
    end
end 