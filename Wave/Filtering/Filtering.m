function Filtering(DataSet,args)
% Filtering.m
% 2008-05-21 Zhang Li
% Wave Filtering and Wave Phase

if isfield(DataSet,'Wave')
    
    if isempty(args)
        isguiinput = 1;
    else
        isguiinput = 0;
        method = args{1};
        issave = args{end};
        param = args(2:end-1);
    end
    
    if isguiinput
        method = questdlg('Which Filter To Use ?',...
            'Filter',...
            'Kaiser','Notch','Kaiser');
    end
    
    switch method
        case 'Kaiser'
            
            if isguiinput
                prompt = {'First Passband :','Second Passband :'};
                dlg_title = 'Kaiser Filter Freq';
                num_lines = 1;
                def = {'1','4'};
                options.Resize='on';
                options.WindowStyle='normal';
                options.Interpreter='tex';
                
                param = inputdlg(prompt,dlg_title,num_lines,def,options);
            end
            Fpb = param{1};
            Spb = param{2};
            
            Ft = Kaiser(DataSet.Wave.fs,param);
            
            hWaitBar=waitbar(0,['Wave Filtering ',Fpb,'-',Spb,' Hz  ...']);
            
            %%%%%%%%%%%%%% Filtering %%%%%%%%%%%%%%%%%
            for i=1:DataSet.Wave.chn
                temp = filtfilt(Ft.numerator,1,DataSet.Wave.wave{i}.wave);
                DataSet.Wave.wave{i}.wave = temp;
                
                waitbar(i/DataSet.Wave.chn,hWaitBar);
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            close(hWaitBar);
            
            DataSet.Dinf.block = [DataSet.Dinf.block,'_F(',Fpb,'-',Spb,')'];
            
        case 'Notch'
             
            if isguiinput
                prompt = {'Notching Freq :','Bandwidth :'};
                dlg_title = 'Notch Filter Freq';
                num_lines = 1;
                def = {'50','1.6'};
                options.Resize='on';
                options.WindowStyle='normal';
                options.Interpreter='tex';
                
                param = inputdlg(prompt,dlg_title,num_lines,def,options);
            end
            Fn = str2double(param{1});
            Bw = str2double(param{2});
            
            
            Ft = CombNotch(DataSet.Wave.fs,param);
            
            hWaitBar=waitbar(0,['Wave Notching ',num2str(Fn-Bw/2),'-',num2str(Fn+Bw/2),' Hz  ...']);
            
            %%%%%%%%%%%%%% Notching %%%%%%%%%%%%%%%
            for i=1:DataSet.Wave.chn
                temp = filtfilt(Ft.numerator,Ft.denominator,DataSet.Wave.wave{i}.wave);
                DataSet.Wave.wave{i}.wave = temp;
                
                waitbar(i/DataSet.Wave.chn,hWaitBar);
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            close(hWaitBar);
            
            DataSet.Dinf.block = [DataSet.Dinf.block,'_N'];
                        
    end
    
    
    if isguiinput
        issave = questdlg('Do you want to save this Filtered DataSet ?',...
            'Save Filtered Data ...',...
            'Yes','No','No');
    end
    
    if strcmp(issave,'Yes')
        filename=[DataSet.Dinf.tank,'__',DataSet.Dinf.block];
        filename=fullfile(DataSet.OutputDir,filename);
        save(filename,'DataSet');
    end
    
    
else
    disp('No Wave Data to Filter !');
    errordlg('No Wave Data to Filter !','Data Error');
end

