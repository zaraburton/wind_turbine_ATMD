%This script is the objective function, when run it will output LCOE
%through passing the parameters, running initTurbPos, running floris,
%convert watts to megawatts, and finally running LCOE calc. The objective
%is to minimise LCOE.

function [x]=objective1(x0)
%% plot positions

figure(2)


% bathymetry data map
[A,R] = readgeoraster('hsb.tif','OutputType','double');
% cropping bathymetry data to fit map better
latlim =[53.68 54.01];
lonlim=[2.18 2.81];
[B,RB] = geocrop(A,R,latlim,lonlim);
%Create a world map by specifying latitude and longitude limits.
latlim = [53.68 54.01];
lonlim = [2.18 2.81];
worldmap(latlim,lonlim)
% show bathymetry data
geoshow(B,RB,'DisplayType','surface')
cb = colorbar;
cb.Label.String = 'Sea Bed Depth in Meters';
% plotting shape outline
% reading hornsea shapefile
S = shaperead('horn3shape.shp');
% showing shape on the map
geoshow(S.Y,S.X);
% Plotting turbine positions
latPLOT = x0(:,1);
longPLOT = x0(:,2);

% plot each turbine as a point
for i=1:length(latPLOT)
    p = geopoint(latPLOT(i),longPLOT(i));
    geoshow(p,'DisplayType','Point');

    if i == 1
        hold on
    end
end
title('New position')
hold off 


%% objective

    [~,lev_cost_en,~]=model1(x0);
    x = lev_cost_en;   


end