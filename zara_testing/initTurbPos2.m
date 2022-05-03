function [florisTurbPos,costTurbPos] = initTurbPos2(numT, hubHeight)
%% Creates initial turbine position arrays for floris (in meters) & cost function (in degrees)

%number of turbines

% reading hornsea shapefile for upper and lower bounds in degrees
S = shaperead('horn3shape.shp');
min_long_x = S.BoundingBox(1,1); % in deg
max_long_x = S.BoundingBox(2,1); % in deg
min_lat_y = S.BoundingBox(1,2); % in deg
max_lat_y = S.BoundingBox(2,2); % in deg

%Theight = 182.5; % turbine height (m)

TurbLL = zeros([numT,2]); % Tubine longitude and latitude coords (degrees) 

for t=1:numT %for turbine 1 - turbine 300 
    % set x/longtitude coord 
    TurbLL(t,2)= min_long_x + (max_long_x-min_long_x).*rand();
    
    % set y/latitide coord
    TurbLL(t,1)= min_lat_y + (max_lat_y-min_lat_y).*rand();   
end

TurbLL;

% Creating turbine centers array for floris input [X, Y, Z]
Tyx = deg2km(TurbLL)*1000; % converting from degrees - km - meters
Tz = hubHeight*ones(numT,1);
florisTurbPos = [Tyx(:,2),Tyx(:,1),Tz]; % (m)

% Turbine long and latidue positions for cost input [lat(y), long(x), 0, 0]
costTurbPos = [TurbLL, zeros([numT,2])]; %turbine cost array

end 



