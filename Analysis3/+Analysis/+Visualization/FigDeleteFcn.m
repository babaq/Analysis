function FigDeleteFcn( hObject, eventdata, handles )
%FIGDELETEFCN Summary of this function goes here
%   Detailed explanation goes here

Analysis.Visualization.savefigure(hObject);

delete(hObject);

end

