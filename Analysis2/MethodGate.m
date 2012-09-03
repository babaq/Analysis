function MethodGate(DataSet,args)
% MethodGate.m %
% 2008.01.15 Zhang Li
% GateWay to different analysis method

if (strcmp(DataSet.Method,'Default Method'))
    switch DataSet.Mark.extype
        case {'sdBar','mdBar','sdGrating','mdGrating','fGrating','fGrating_Surround','RF_Size','CenterSurround'}
            TuningCurve(DataSet,args);
        case {'RF_sfBar','RF_mfBar','RF_sdBar','RF_mdBar','RF_Center','RF_Surround','RF_sfBar_Surround','RF_mfBar_Surround'}
            RF(DataSet,args);
        otherwise
            disp('No Default Analysis Method, Choose One First !');
            warndlg('Please Choose Analysis Method !','No Default Method !');
    end
else
    switch DataSet.Method
        case 'Raw Data'
            RawData(DataSet,args);
        case 'RF'
            RF(DataSet,args);
        case 'Filtering'
            Filtering(DataSet,args);
        case 'PSTH'
            PSTH(DataSet,args);
        case 'Tuning Curve'
            TuningCurve(DataSet,args);
        case 'Correlation'
            Correlation(DataSet,args);
        case 'Phase of Firing'
            FiringPhase(DataSet,args);
        case 'Spike-Triggered Averaging'
            STA(DataSet,args);
        otherwise
    end
end