function [ description ] = EvTypeToString( TTX, evtypecode )
%EVTYPETOSTRING returns a string description for event type codes. An event type
%               is the type of event, such as snippet, strobe, or streamed data.
%input:
%   DefinedEventTypes  EventType    HexValue    Returns
%   EVTYPE_UNKNOWN      unknown     0x00000000 "Unknown"
%   EVTYPE_STRON        Strobe ON   0x00000101 "Strobe+"
%   EVTYPE_STROFF       Strobe OFF  0x00000102 "Strobe-"
%   EVTYPE_SCALAR       Scalar      0x00000201 "Scalar"
%   EVTYPE_STREAM       Stream      0x00008101 "Stream"
%   EVTYPE_SNIP         Snip        0x00008201 "Snip"
%   EVTYPE_MARK         Marker      0x00008801 "Mark"
%   EVTYPE_HASDATA   waveform data  0x00008000 "HasData"

description = TTX.EvTypeToString(evtypecode);
end

