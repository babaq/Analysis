function [ description ] = DFromToString( TX, dformcode )
%DFROMTOSTRING converts a data format code to a descriptive string
%input:
%   dformcode
%       DefinedDataFormat  Format Value Returns
%       DFORM_FLOAT         float   0   "Float"
%       DFORM_LONG          long    1 	"Long"
%       DFORM_SHORT         short   2   "Short"
%       DFORM_BYTE          byte    3   "Byte"
%       DFORM_DOUBLE        double  4   "Double"

description = TX.DFromToString(dformcode);
end

