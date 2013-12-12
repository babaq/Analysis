classdef VLabGlobal
    %VLABGLOBAL 
    %   Only Single Unit should be recorded and each well sorted SU should be
    %   recorded in different channel.
    
    properties(Constant)
        % Task States
        ITI = 0;
        ITI2 = 1;
        TARGET_ON = 2;
        FOREP = 3;
        TARGET_FLIP = 4;
        TARGET_OFF = 5;
        FIG_ON = 6;
        FIG_OFF = 7;
        FOREP1 = 8;
        ISI = 18;
        ISI2 = 19;
        FIX_ACQUIRED = 101;
        AXISFORCED = 102;
        REACTIONALLOWED = 103;
        % Spike Recording Time Resolution (ms)
        TICK = 0.1;
        % Impossible Time
        INVALIDTIME = -600000;
        % Task Status
        TASKTRIAL_NONE = 0;
        TASKTRIAL_EARLY = 1;
        TASKTRIAL_HIT = 2;
        TASKTRIAL_MISS = 3;
        TASKTRIAL_CONTINUE = 4;
        TASKTRIAL_END = 5;
        TASKTRIAL_FAIL = 6;
        TASKTRIAL_REPEAT = 7;
        TASKTRIAL_EARLY_HOLD = 11;
        TASKTRIAL_EARLY_RELEASE = 12;
    end
    
    methods
    end
    
end

