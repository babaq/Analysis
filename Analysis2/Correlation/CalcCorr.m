function cdata = CalcCorr(DataSet,lag_n,bin_n,ch_n1,sort1,ch_n2,sort2,isauto)
% CalcCorr.m
% 2011-04-03 by Zhang Li
% Spike Train Cross/Auto Correlation Function

extent = DataSet.Dinf.extent;
delay = DataSet.Dinf.delay;
if ischar(sort1)
    if strcmp(sort1,'NOSORT')
        errordlg('NO SORT DATA TO SHOW !','Data Error ');
        return;
    end
    if strcmpi(sort1,'MU')
        sort_n1 = 0;
    else
        sort_n1 = str2double(sort1(3:end));
    end
else
    sort_n1 = sort1;
end
if ischar(sort2)
    if strcmp(sort2,'NOSORT')
        errordlg('NO SORT DATA TO SHOW !','Data Error ');
        return;
    end
    if strcmpi(sort2,'MU')
        sort_n2 = 0;
    else
        sort_n2 = str2double(sort2(3:end));
    end
else
    sort_n2 = sort2;
end
        
if sort_n1==0 % MU
    sort_n1 = DataSet.Snip.ppsortn(ch_n1);
end
if sort_n2==0 % MU
    sort_n2 = DataSet.Snip.ppsortn(ch_n2);
end

%%%%%%%%%%%%%%%%%%% Calculate Correlation %%%%%%%%%%%%%%%%%%%  
bw = 0.0001; % lagging resolution set to 0.1ms
lag_nn = lag_n/(bw*1000);
bin_nn = bin_n/(bw*1000);
corr_n = floor(lag_n/bin_n);
centerindex = corr_n+1;


data = zeros(DataSet.Mark.trial,DataSet.Mark.stimuli,2*corr_n+1);

for s=1:DataSet.Mark.stimuli
    for t=1:DataSet.Mark.trial
        
        st1 = DataSet.Snip.snip{ch_n1,sort_n1}.ppspike{t,s};
        st2 = DataSet.Snip.snip{ch_n2,sort_n2}.ppspike{t,s};
        onofftime = [DataSet.Mark.on(t,s)-extent+delay DataSet.Mark.off(t,s)+extent+delay];
        
        bst1 = binst(st1,onofftime,bw);
        bst2 = binst(st2,onofftime,bw);
        temp = xcorr(bst1,bst2,lag_nn);
        
        cn = lag_nn + 1;
        data(t,s,centerindex) = temp(cn);
        
        j = centerindex + 1;
        for i = cn+1:bin_nn:length(temp)
            data(t,s,j) = sum(temp(i:i+(bin_nn-1)));
            j = j + 1;
        end
        
        j = centerindex - 1;
        for i = cn-1:-bin_nn:1
            data(t,s,j) = sum(temp(i-(bin_nn-1):i));
            j = j - 1;
        end

        % Auto Correlation Correction
        if (ch_n1==ch_n2) && (sort_n1==sort_n2) && isauto
            data(t,s,:) = (data(t,s,:)/data(t,s,centerindex))*100; % percentage of nomalized correlation
            data(t,s,centerindex) = (data(t,s,centerindex-1)+data(t,s,centerindex+1))/2;
            data(t,s,:) = data(t,s,:)-mean(data(t,s,:));
        end

    end
end

cdata.data = data;

% Correlation Parameters
cdata.params.lag_n = lag_n;
cdata.params.bin_n = bin_n;
cdata.params.ch_n1 = ch_n1;
cdata.params.sort1 = sort1;
cdata.params.ch_n2 = ch_n2;
cdata.params.sort2 = sort2;
