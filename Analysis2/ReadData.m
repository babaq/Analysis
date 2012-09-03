function Data = ReadData(filename,pathname)
% ReadData.m
% 2008-03-14 Zhang Li
% Read Viarous Formated, Exported Data (*.csv *.mat *.nsn ...)

cd (deblank(pathname));


if iscell(filename) % more than one files
    file_n =length(filename);
    if(file_n>3)
        disp('Too Many Data Files Selected !');
        errordlg('Too Many Data Files Selected !','Too Many Data ');
        return;
    else
        Data.Dinf.server = 'Exported';
        Data.Dinf.tank = 'Exported';
        % Check multiple datafiles(mark,snip,wave) if they belong to the same block
        for i=2:file_n
            file1=filename{i-1};
            file2=filename{i};
            block1=file1;
            block2=file2;
            if(~strcmpi(block1,block2))
                disp('Data Files Do Not Belong to the Same Block !');
                errordlg('Data Files Do Not Belong to the Same Block !','Not Same Block');
                return;
            end
            
            Data.Dinf.block = block2;          
            
        end

        % Begin Read Data
        for i=1:file_n
            Data=csvread(filename{i},1,3);
        end
        
    end
else % just one file
    temp=findstr(filename,'.');
    filetype=filename(temp(end)+1:end);
    
    switch filetype
        case 'mat' % Analysis Saved DataSet
            DataSet=load(filename);
            Data = DataSet.DataSet;
        case 'nsn' % NeuroShare Native Data Format
            
        otherwise
            disp('File Format Not Supported !');
            errordlg('File Format Not Supported !','File Type Error ');
            return;
    end
    
end
