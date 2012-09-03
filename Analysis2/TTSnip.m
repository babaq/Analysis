function CSnip = TTSnip(TTX,ActEvent,Options)
% TTSnip.m
% 2011-03-17 Zhang Li
% Read Snip Event from TTank ActiveX Control

if (length(ActEvent)>4) % TDT OpenSorter Offline-Sorted Data
    % Get Real Event and Sort Name
    temp=findstr(ActEvent,'_');
    eventname = ActEvent(1:(temp(end)-1));
    sortset = ActEvent((temp(end)+1):end);
else % TDT OpenEx Online-Sorted Data
    eventname = ActEvent;
    sortset = 'TankSort';
end
    
% get current event channal number, waveform sample number and samplingfreq from block note
note = TTX.CurBlockNotes;
CSnip = BlockNote(note,eventname);
ch_n = CSnip.chn;

%_______________Read Snip Data_________________%
TTX.SetUseSortName(sortset);
maxsort=10; % Max sortnumber per channal
CSnip.spevent = ActEvent;
CSnip.sortn = zeros(ch_n,1);


%     hWaitBar=waitbar(0,'Reading All Channal Spikes ...');
if strcmp(sortset,'TankSort') % TDT OpenEx Online-Sorted Data
    for i=1:ch_n
        
        for j=0:maxsort-1 % begin with 0
            TTX.ResetFilters;
            TTX.SetFilterWithDescEx(['CHAN=',num2str(i),' and SORT=',num2str(j)]);
            
            sortsnip_n=TTX.ReadEventsV(10000000,eventname, i, j, 0.0, 0.0,'Filtered');
            if (sortsnip_n==0) % end of sortcode
                break;
            else
                temp=TTX.ParseEvInfoV(0, sortsnip_n, 6);
                CSnip.snip{i,j+1}.spike=temp;
                
                if Options.spikewave
                    temp1=TTX.ParseEvV(0, sortsnip_n);
                    CSnip.snip{i,j+1}.spikewave={temp temp1};
                end
                
                CSnip.sortn(i)=j+1;
                CSnip.snipn{i,j+1} = sortsnip_n;
            end
        end
        
        %              waitbar(i/ch_n,hWaitBar);
        
    end
else % TDT OpenSorter Offline-Sorted Data
    for i=1:ch_n
        
        for j=1:maxsort % discard outliers(O), Unsorted(U), and begin with sortcode_1
            TTX.ResetFilters;
            TTX.SetFilterWithDescEx(['CHAN=',num2str(i),' and SORT=',num2str(j)]);
            
            sortsnip_n=TTX.ReadEventsV(10000000,eventname, i, j, 0.0, 0.0,'Filtered');
            if (sortsnip_n==0) % end of sortcode
                break;
            else
                temp=TTX.ParseEvInfoV(0, sortsnip_n, 6);
                CSnip.snip{i,j}.spike=temp;
                
                if Options.spikewave
                    temp1=TTX.ParseEvV(0, sortsnip_n);
                    CSnip.snip{i,j}.spikewave={temp temp1};
                end
                
                CSnip.sortn(i)=j;
                CSnip.snipn{i,j} = sortsnip_n;
            end
        end
        
        %             waitbar(i/ch_n,hWaitBar);
        
    end
end
%     close(hWaitBar);
