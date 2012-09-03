function vs = ValidSessions(sn,invalidsessions,exid,extype)
% ValidSessions.m %
% 2011-04-21 by Zhang Li
% Get Experiment Valid Sessions according to user defined invalid session index


if ischar(invalidsessions) % InvalidSessions file path
    f = ['InvalidSessions_',num2str(exid),'_',extype];
    IS = load(fullfile(invalidsessions,[f,'.mat']));
    IS = IS.(f);
else
    IS = invalidsessions;
end

vs = 1:sn;
for i =1:length(IS)
    vs(IS(i)) = [];
end

 