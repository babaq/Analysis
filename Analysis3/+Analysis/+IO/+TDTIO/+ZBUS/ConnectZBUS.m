function [ hr ] = ConnectZBUS( ZBX,interface )
%CONNECTZBUS Establishes a connection with a ZBUS device interface (GB or USB).
%Input:
%      interface: Interface to which the device is connected.
%                   Argument   Connection     Part #s
%                   'GB'         Gigabit      PI5/FI5, PO5/FO5
%                   'USB'          USB        UZ2, UB2, UZ1, UZ4

hr = ZBX.ConnectZBUS(interface);
if hr==0
    hr = false;
else
    hr = true;
end

end

