classdef CellAssemble < handle
    %CELLASSEMBLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        cells
    end
    
    methods
        function ca = CellAssemble(n)
            import Analysis.Core.Cell
            ca.cells = Cell.empty;
            if nargin==1
                ca.name = n;
            end
        end
    end
    
end

