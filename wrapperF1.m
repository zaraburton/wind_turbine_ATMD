%wrapper module 1 - fmincon

clear all
close all

notes = 'Only monopile support';
%% Initialisation

numT=10;
hubHeight=206;
%[turbine_centres,~] = initTurbPos(numT, hubHeight);
[florisTurbPos,costTurbPos] = initTurbPos2(numT, hubHeight);

%% plot initial positions

f1=figure;
% plot bathymetry data


    % bathymetry data 
    [a,R] = readgeoraster('hsb.tif','OutputType','double');
    latlim = R.LatitudeLimits;
    longlim = R.LongitudeLimits;
    info = geotiffinfo('hsb.tif');
    height = info.Height; % Integer indicating the height of the image in pixels
    width = info.Width; % Integer indicating the width of the image in pixels
    x = 1:width;
    y = 1:height;
    [rows,cols] = meshgrid(1:height,1:width);
    [ADlat,ADlon] = pix2latlon(info.RefMatrix, rows, cols);
    
    % LCOE func WANTS ADLAT, ADLONG, A - setting global bathymetry data to
    % speed up
    bath=[ADlat,ADlon];
    setGlobalB(bath);
    setGlobalA(a);


% cropping bathymetry data to fit map plot better
latlim =[53.68 54.01];
lonlim=[2.18 2.81];
[B,RB] = geocrop(a,R,latlim,lonlim);

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
%S = shaperead('horn3shape.shp');
setGlobalS(shaperead('horn3shape.shp'))
S = getGlobalS;

% use: hornshape = S.Geometry to get coordinates of each corner
x1 = S.X;
y1 = S.Y;
%orangeline = makesymbolspec('patch',{'Default','EdgeColor','#FF7401'});
%%orange line
% showing shape on the map
geoshow(S.Y,S.X);


% Plotting turbine positions

latINIT = costTurbPos(:,1);
longINIT = costTurbPos(:,2);

% plot each turbine as a point
for i=1:length(latINIT)
    p = geopoint(latINIT(i),longINIT(i));
    geoshow(p,'DisplayType','Point');

    if i == 1
        hold on
    end
end

title('Initial Position')

hold off 


%% Optimisation

% function
fun = @objective1;

%geographical bounds for the wind farm
lb=zeros(numT,2);
ub=zeros(numT,2);

% reading hornsea shapefile for upper and lower bounds in degrees

min_long_x = S.BoundingBox(1,1); % in deg
max_long_x = S.BoundingBox(2,1); % in deg
min_lat_y = S.BoundingBox(1,2); % in deg
max_lat_y = S.BoundingBox(2,2); % in deg

lb(:,1)=min_lat_y; 
lb(:,2)=min_long_x;
ub(:,1)=max_lat_y; 
ub(:,2)=max_long_x;


% other empty constriants
A = [];
b = [];
Aeq = [];
beq = [];
nonlcon = @mycon;

%starting point
%x0=turbine_centres(:,1:2)
x0 = costTurbPos(:,1:2);


options1 = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed','PlotFcn','optimplotfval');
options2 = optimoptions('fmincon','Algorithm',"interior-point",'Display','iter-detailed','PlotFcn','optimplotfval', 'MaxFunctionEvaluations',1000*numT, 'FunctionTolerance', 0.0000001);

[x,fval,exitflag,output,lambda,grad,hessian]=fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options2)
%[x,fval] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub);



%% Result visualisation


fval


txt = {['LCOE: ',num2str(fval)],['Num Turbines: ',num2str(numT)], notes};

f2=figure;
% plot bathymetry data
worldmap(latlim,lonlim)
% show bathymetry data
geoshow(B,RB,'DisplayType','surface')
cb = colorbar;
cb.Label.String = 'Sea Bed Depth in Meters';


% plotting shape outline
% showing shape on the map
geoshow(S.Y,S.X);


% Plotting turbine positions
latPos = x(:,1);
longPos = x(:,2);

% plot each turbine as a point
for i=1:length(latPos)
    p = geopoint(latPos(i),longPos(i));
    geoshow(p,'DisplayType','Point');

    if i == 1
        hold on
    end
end

title(txt)

hold off 


% %figure 1: default position
% figure(2)
% plot(x0(:,1)/111139,x0(:,2)/111139,'bd');
% title('Default position');
% xlabel('Longtitude'), ylabel('Latitude');
% 
% %figure 2: optimised position
% figure(3)
% plot(xopt(:,1)/111139,xopt(:,2)/111139,'rd');
% title('Optimised position');
% xlabel('Longtitude'), ylabel('Latitude');
% 
% %figure 3: position together
% figure(4)
% hold
% plot(x0(:,1)/111139,x0(:,2)/111139,'bd');
% plot(xopt(:,1)/111139,xopt(:,2)/111139,'rd');
% title('Both');
% xlabel('Longtitude'), ylabel('Latitude');
% legend('default position','optimised position');

%figure 4: LCOE
% figure(4)
% plot(LCOE);
