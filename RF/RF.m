function RF(DataSet,args)
% RF.m
% 2009-06-22 by Zhang Li
% Gate to RF GUI

global RFData;
RFData = DataSet;

switch DataSet.Mark.extype
    case {'RF_sfBar','RF_mfBar','RF_sfBar_Surround','RF_mfBar_Surround'}
        % GUI Interface to Flashing Bar Reverse-Correlation RF Maping
        MainRF_fBar;
    case {'RF_sdBar','RF_mdBar'}
        % GUI Interface to Drifting Bar RF Maping
        MainRF_dBar;
    case {'RF_Center','RF_Surround'}
        if strcmp(DataSet.Mark.ticktype,'one')
            % GUI Interface to Flashing Grating Reverse-Correlation RF Maping
            MainRF_fBar;
        else
            % GUI Interface to Grating RF Maping
            MainRF_Grating;
        end
    otherwise  
end


