
fname='bdotpj';
flag = 1;
if flag == 0
    GenStkAttFileFromSimOut(epoch, TrueQuatEci2Body.Time, TrueQuatEci2Body.Data,fname);
    GenStkEphFileFromSimOut(epoch, PosVelEciMeter.Time, PosVelEciMeter.Data,fname);
else
    GenStkAttFileFromSimOut(dm.init.epochUTC, TrueQuatEci2Body.Time, TrueQuatEci2Body.Data,fname);
    GenStkEphFileFromSimOut(dm.init.epochUTC, PosVelEciMeter.Time, PosVelEciMeter.Data,fname);
end


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
SatelliteName = fname;
AttitudeFileName = strcat(fname,'_quat.a');
EphemerisName    = strcat(fname,'_ephem.e');
ModelName = 'FS-8_20190531.mdl';
epochSTK = datestr(dm.init.epochUTC,'dd mmm yyyy HH:MM:SS.000');
%%
% Create a new scenario and specify the time
try
    root.CloseScenario();
    root.NewScenario(SatelliteName);
catch
    root.NewScenario(SatelliteName);
end


% Set Scenario time
root.CurrentScenario.SetTimePeriod(epochSTK, strcat('+',num2str(dm.init.duration),' sec'));
root.Rewind;

path=pwd;
%%
% Create new satellite and propagate from external file
satNSPO = root.CurrentScenario.Children.New('eSatellite',SatelliteName);
% add external attitude & ephemeris files
root.ExecuteCommand(strcat('AddAttitude */Satellite/',SatelliteName,' File  "',path,'\',AttitudeFileName,'"'));
root.ExecuteCommand(strcat('SetState */Satellite/',SatelliteName,' FromFile "',path,'\',EphemerisName,'"'));


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