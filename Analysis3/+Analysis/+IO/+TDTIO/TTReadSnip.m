function [ chc ] = TTReadSnip( TX,eventname,options, varargin )
%TTREADSNIP Summary of this function goes here
%   Detailed explanation goes here
import Analysis.Core.* Analysis.IO.TDTIO.* Analysis.IO.TDTIO.TTankX.*

if nargin<3
    options.readoptions = 'FILTERED';
    options.isreadspikewave = true;
end
if nargin == 4
    evinfov = varargin{1};
end

if length(eventname)>4 % TDT OpenSorter Offline-Sorted
    % Get Real Event and Sort Name
    t=strfind(eventname,'_');
    sortset = eventname(t(1)+1:end);
    evname = eventname(1:t(1)-1);
    % discard Outliers(O) and Unsorted(U), begin with Sort 1
    sortstart = 1;
else % TDT Online-Sorted
    evname = eventname;
    sortset = 'TankSort';
    % begin with Unsorted(0)
    sortstart = 0;
end
evinfob = BNEvInfo(CurBlockNotes(TX),evname);
if ~SetUseSortName(TX,sortset);
    error('Sort Profile: %s Set Failed.',sortset);
end

chc = ChannelCluster('all');
for i = 1:evinfob.NumChan
    ch = Channel(i);
    s = 1; % sort counting
    for j = sortstart:Globals.MaxSort
        ResetFilters(TX);
        if ~SetFilterWithDescEx(TX,['chan=',num2str(i),' and sort=',num2str(j)]);
            error('Filter Failed.');
        end
        snipn=ReadEventsV(TX,Globals.MaxRet,evname, 0, 0, 0, 0,options.readoptions);
        if snipn == Globals.MaxRet
            warning('Maximum number of records(%d) is returned indicating more records in the event',...
                snipn);
        elseif snipn==0 % end of sortcode
            break;
        end
        
        tst = ParseEvInfoV(TX,0,snipn,6);
        if options.isreadspikewave
            tsw = ParseEvV(TX,0,snipn);
        end
        
        st = SpikeTrain(eventname);
        for n = 1:snipn
            sp = Spike(i,tst(n),j);
            if options.isreadspikewave
                sp.fs = evinfob.SampleFreq;
                sp.value = tsw(:,n);
            end
            st.spikes(n,1) = sp;
        end
        
        ch.spiketrains(s,1) = st;
        s = s + 1;
    end
    chc.channels(i,1) = ch;
end
ResetFilters(TX);

