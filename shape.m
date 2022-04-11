% geographical boundaries

% reading hornsea shapefile
S = shaperead('horn3shape.shp')
% use: hornshape = S.Geometry to see what bits r called

% boundary coordinates
x1 = S.X
y1 = S.Y

% showing the map
mapshow(x1,y1,'DisplayType','polygon')

geoplot(y1,x1)