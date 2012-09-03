function SDataSet = ReadSoul(srf)
% ReadSoul.m
% 2010-04-24 Zhang Li
% read Soul simulation system record files data

%% check file name
dot = findstr(srf,'.');
filetype = srf(dot(end)+1:end);
if(~strcmp(filetype,'txt'))
    disp('File Type is not TXT !');
    return;
end
lower = findstr(srf,'_');
recordtype = srf(lower(end)+1);
if(recordtype~= 'v'&& recordtype~='s')
    disp('Record Type Error !')
    return;
end
SDataSet.recordtime = srf(lower(end-2)+1:lower(end)-1);

%% open file
[hfile,hr] = fopen(srf,'r');
if hfile == -1
    disp(hr);
    return;
end

%% get first data file 
SDataSet.summary = head(hfile);
if(recordtype=='v')
    SDataSet.potential = potential(hfile);
    recordtype='s';
    srf_other = srf;
    srf_other(lower(end)+1)=recordtype;
else
    SDataSet.spike = spike(hfile);
    recordtype='v';
    srf_other = srf;
    srf_other(lower(end)+1)=recordtype;
end
fclose(hfile);

%% open another file
[hfile,hr] = fopen(srf_other,'r');
if hfile == -1
    disp(hr);
    return;
end

%% get second data file
if(recordtype=='v')
    SDataSet.potential = potential(hfile);
else
    SDataSet.spike = spike(hfile);
end
fclose(hfile);


%%% parse header
    function header = head(hfile)
        header.dt = 0.1;
        header.duration = 20;
    end
%%% get potential data
    function potential = potential(hfile)
        Data =textscan(hfile,'%n %n %s','commentStyle','#','delimiter','\t');
        times=Data{1};
        time = unique(times);
        outputs=Data{2};
        ids=Data{3};
        id=unique(ids);
        n=length(id);
        data = cell(n,1);
        for i=1:n
            index = find(strcmp(ids,id(i)));
            indexn = length(index);
            data{i} = zeros(1,indexn);
            for j=1:indexn
                data{i}(j)=outputs(index(j));
            end
        end
        potential.data = cell2mat(data);
        potential.n=n;
        potential.id=id;
        potential.time = time;
    end
%%% get spike data
    function spike = spike(hfile)
        Data =textscan(hfile,'%n %s','commentStyle','#','delimiter','\t');
        times = Data{1};
        ids = Data{2};
        id = unique(ids);
        n = length(id);
        data = cell(n,1);
        for i=1:n
            index = find(strcmp(ids,id(i)));
            indexn = length(index);
            data{i} = zeros(1,indexn);
            for j=1:indexn
                data{i}(j)=times(index(j));
            end
        end
        spike.id = id;
        spike.n = n;
        spike.data = data;
    end

end % eof