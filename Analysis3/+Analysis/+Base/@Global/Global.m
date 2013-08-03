classdef Global
    %GLOBAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        % Minimum 100 kHz sampling of Spike is required to get spike info
        MinFs = 100000;
        % Minimum RMS of action potential waveform (V)
        MinAPRMS = 0.002;
    end
    
    methods
    end
    
end

