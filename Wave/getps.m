function ps = getps(psd,freqrange,timerange)
% getps.m
% 2010-3-12 by Zhang Li
% Organize power spectrum according to type and frequency range


vi = cellfun(@(x)~isempty(x),psd{1});
vi = find(vi==1);
vc = psd{1}(vi);
fn = cellfun(@(x)length(x.frequencies),vc);
dfi = find(fn==max(fn));
df = vc{dfi(1)}.frequencies;
dfn = length(df);
vi = vi(dfi(1));
ivdata = ones(1,dfn)*NaN;

freqindex = (psd{1}{vi}.frequencies>=freqrange(1)) & (psd{1}{vi}.frequencies<=freqrange(2));
isphase = isfield(psd{1}{vi},'phase');
istime = isfield(psd{1}{vi},'time');
if istime
    if isempty(timerange)
        timerange = [0 max(psd{1}{vi}.time)];
    else
        timerange = timerange/1000; % sec
    end
    timeindex = (psd{1}{vi}.time>=timerange(1)) & (psd{1}{vi}.time<=timerange(2));
end
chn = length(psd)-1;
tn = size(psd{1},1);
sn = size(psd{1},2);
for i = chn
    for t = 1:tn
        for s = 1:sn
            tpsd = psd{i}{t,s};
            isv = ~isempty(tpsd);
            if istime
                if isv
                    ps{i}.data(t,s,:,:) = tpsd.data(timeindex,freqindex);
                else
                    ps{i}.data(t,s,:,:) = NaN;
                end
            else
                if isv
                    if length(tpsd.frequencies)<dfn;
                        tpsd.data = interp1(tpsd.frequencies,tpsd.data,df,'spline');
                    end
                    ps{i}.data(t,s,:) = tpsd.data(freqindex);
                else
                    ps{i}.data(t,s,:) = ivdata(freqindex);
                end
            end
            if isphase
                if isv
                    if length(tpsd.frequencies)<dfn;
                        tpsd.phase = interp1(tpsd.frequencies,tpsd.phase,df,'spline');
                        disp('Error, Phase Linear Interpolation !');
                    end
                    ps{i}.phase(t,s,:) = tpsd.phase(freqindex);
                else
                    ps{i}.phase(t,s,:) = ivdata(freqindex);
                end
            end
        end
    end
end
ps{chn+1} = psd{end};
ps{chn+1}.frequencies = psd{1}{vi}.frequencies(freqindex);
if istime
    ps{chn+1}.time = psd{1}{vi}.time(timeindex);
end


