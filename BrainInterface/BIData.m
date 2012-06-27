function waveform = BIData()
% BrainInterface.m
% 2008-12-28 by Zhang Li
% Gate of BrainInterface

Dinf.DataLength = 1;
TTX = actxcontrol('TTank.X');
TTX.ConnectServer('Local','AlexBI');
TTX.OpenTank('E:\Zl\TDT System 3\OpenEx Projects\Single\DataTanks\Single_DT1_122908','M');
TTX.SelectBlock('~TempBlk');

TTX.SetGlobalV('Channel',1);
TTX.SetGlobalStringV('Options','NEW');
% start = TTX.CurBlockStartTime;
% start = TTX.FancyTime(start ,'D/O/Y H:M:S.U W');
% start = datevec(start);
% nowt = datevec(now);
% tet = etime(nowt,start);
% et = tet-Dinf.DataLength;
% saming = TTX.GetCodeSpecs(TTX.StringToEvCode('FP01'));
% sam = TTX.EvSampFreq;
% TTX.SetGlobalV('T1',et*sam);
% TTX.SetGlobalV('T2',tet*sam);

%TTX.ResetFilters;
% global onoff;
% onoff=true;
% sin = figure('CloseRequestFcn',@figclose);
% 
% %pro = figure;
% lastrms=0;
    
while (1)
     pause(1);
%         if (~onoff)
%             break;end
%     disp(onoff);
    %TTX.SetFilterWithDescEx('Freq=2000 and Levl=0')
    
    wave = TTX.ReadEventsSimple('FP01');
    waveform = TTX.ParseEvV(0,0);
    save waveform;
    disp(wave);
% %     cl = size(waveform,2);
% %     w=[];
% %     for i=1:cl
% %     w= cat(1,w,waveform(:,i));
% %     end
% subplot(2,1,1);
% figure(sin)
%     plot(waveform);
%     
%     
%     
%     
% %     TTX.CloseTank;
% %     TTX.ReleaseServer;
% out = rms(waveform);
% subplot(2,1,2);
% figure(sin)
% plot(out);
% 
% 
% if(abs(out-lastrms)>(lastrms/10))
%     disp('write');
%     parport = digitalio('parallel','LPT1');
% addline(parport,0:7,'out');
% 
% putvalue(parport,5);
% 
% lastrms = out;
% end
% 
% 
% 
% 
end
% 
% function figclose(hObject, eventdata, handles)
% global onoff;
% onoff = ~onoff;
% delete(hObject);

