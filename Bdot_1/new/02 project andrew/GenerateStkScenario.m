%% Initialize scenario and grab appropriate handles
clc

try
    % Grab an existing instance of STK
    app = actxGetRunningServer('STK11.application');
catch
    % STK is not running, launch new instance
    % Launch a new instance of STK and grab it
    app = actxserver('STK11.application');
end

root = app.Personality2;
app.visible = 1;
AnimTimeStep = 3;
SatelliteName = 'FS702';
AttitudeFileName = 'fs7_aocs_sim_quat.a';
ModelName = 'FS-7_datum.mdl';
TEL_1 = '1 44351U 19036N   20011.46192255  .00000276  00000-0  12272-4 0  9997';
TLE_2 = '2 44351  24.0009  22.2412 0022995 193.1623 166.8270 14.56498513 29129';

% Create a new scenario and specify the time
try
    root.CloseScenario();
    root.NewScenario(SatelliteName);
catch
    root.NewScenario(SatelliteName);
end

epoch=datestr(dm_ini.epoch,'dd mmm yyyy HH:MM:SS.000');  
duration = dm_ini.duration;

% Set Scenario time
root.CurrentScenario.SetTimePeriod(epoch, strcat('+',num2str(duration),' sec'));
root.Rewind;

path=pwd;

% Create new satellite and propagate from external file
satNSPO = root.CurrentScenario.Children.New('eSatellite',SatelliteName);
satNSPO.SetPropagatorType('ePropagatorSGP4');
sensor = satNSPO.Children.New('eSensor','ConsignSunVector');
u = df_ini.desired_Sun_pointing_vector_panel_deployed;
el = asind(u(3));
az = atan2d(u(2), u(1));
root.ExecuteCommand(strcat('Define */Satellite/',SatelliteName,'/Sensor/ConsignSunVector SimpleCone 0.001'));
root.ExecuteCommand(char(strcat('Point */Satellite/',SatelliteName,'/Sensor/ConsignSunVector Fixed AzEl',{' '},num2str(az),{' '},num2str(el))));
root.ExecuteCommand(strcat('VO */Satellite/',SatelliteName,'/Sensor/ConsignSunVector SetVectorGeometry Modify "Satellite/',SatelliteName,'/Sensor/ConsignSunVector Boresight Vector" Show On ShowLabel Off'));
root.ExecuteCommand(strcat('VO */Satellite/',SatelliteName,'/Sensor/ConsignSunVector SetVectorGeometry Data Scale 6.5'));
root.ExecuteCommand(strcat('VO */Satellite/',SatelliteName,'/Sensor/ConsignSunVector SetVectorGeometry Modify "Satellite/',SatelliteName,'/Sensor/ConsignSunVector Sun Angle" Show On'));
% root.ExecuteCommand(strcat('DisplayTimes */Satellite/',SatelliteName,'/Sensor/ConsignSunVector State AlwaysOn'));
% add TLE
root.ExecuteCommand(char(strcat('SetState */Satellite/',SatelliteName,' TLE "',TEL_1,{'" "'},TLE_2,'"')));

% add attitude
root.ExecuteCommand(strcat('AddAttitude */Satellite/',SatelliteName,' File  "',path,'\',AttitudeFileName,'"'));

%add 3D model
root.ExecuteCommand(strcat('VO */Satellite/',SatelliteName,' Model File  "',path,'\',ModelName,'"'));
root.ExecuteCommand(char(strcat('VO */Satellite/',SatelliteName,' ScaleModel',{' '},num2str(10^6.1))));
root.ExecuteCommand(strcat('VO */Satellite/',SatelliteName,' ModelDetail Set All 63095000 ModelLabel 63095000 MarkerLabel 63095000 Marker 63095000'));

%add vectors
root.ExecuteCommand(strcat('VO */Satellite/',SatelliteName,' SetVectorGeometry Modify "Satellite/',SatelliteName,' Sun Vector" Show On'));
root.ExecuteCommand(strcat('VO */Satellite/',SatelliteName,' SetVectorGeometry Modify "Satellite/',SatelliteName,' Body Axes" Show On'));
root.ExecuteCommand(strcat('VO */Satellite/',SatelliteName,' SetVectorGeometry Data Scale 6.5'));

                                                                                  
propagator = satNSPO.Propagator;
propagator.Propagate;
