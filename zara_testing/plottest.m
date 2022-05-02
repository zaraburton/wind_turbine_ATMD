clear()

%% getting turbine positions (plot the cost ones, as they're in degrees)
numT=10;
hubHeight = 160;
[florisTurbPos,costTurbPos] = initTurbPos2(numT, hubHeight);

%% plot bathymetry data 

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

%% plotting shape outline

% reading hornsea shapefile
S = shaperead('horn3shape.shp');

% use: hornshape = S.Geometry to get coordinates of each corner
x1 = S.X;
y1 = S.Y;


%orangeline = makesymbolspec('patch',{'Default','EdgeColor','#FF7401'}); %orange line
% showing shape on the map
geoshow(S.Y,S.X);


%% Plotting turbine positions

latPos = costTurbPos(:,1);
longPos = costTurbPos(:,2);

% plot each turbine as a point
for i=1:length(latPos)
    p = geopoint(latPos(i),longPos(i));
    geoshow(p,'DisplayType','Point');

    if i == 1
        hold on
    end
end

hold off 
