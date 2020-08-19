GenStkAttFileFromSimOut(epoch, TrueQuatEci2Body.Time, TrueQuatEci2Body.Data,fname);
root.ExecuteCommand(strcat('AddAttitude */Satellite/',SatelliteName,' File  "',path,'\',AttitudeFileName,'"'));
disp('update attitude done');