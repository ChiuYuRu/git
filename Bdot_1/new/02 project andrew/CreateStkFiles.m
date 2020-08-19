function CreateStkFiles(epoch_date_vector,TrueQuatEci2Body,PosVelEciMeter, fn)

if nargin <4
    fn = 'fs8_aocs_sim';
end

GenStkAttFileFromSimOut(epoch_date_vector, TrueQuatEci2Body.Time,...
                                           TrueQuatEci2Body.Data, fn );
                                       
GenStkEphFileFromSimOut(epoch_date_vector, PosVelEciMeter.Time,...
                                           PosVelEciMeter.Data, fn);
% disp('Generating STK attiude file...');
% epoch=datestr(evalin('base','dm_ini.epoch'),'dd mmm yyyy HH:MM:SS.000');
% 
% if nargin ==1
%     epoch = varargin{1};
% end
% trueQECI2Body=evalin('base','TrueQuatEci2Body.Data');
% trueQECI2Body = trueQECI2Body';
% t=evalin('base','TrueQuatEci2Body.Time');
% t = t';
% len = size(trueQECI2Body,2);
% fid = fopen('fs7_aocs_sim_quat.a','w');
% fprintf(fid, 'stk.v.7.0\n');
% fprintf(fid, 'BEGIN Attitude\n');
% fprintf(fid, 'NumberOfAttitudePoints      %d\n',len);
% fprintf(fid, 'BlockingFactor              20\n');
% fprintf(fid, 'InterpolationOrder           1\n');
% fprintf(fid, 'CentralBody Earth\n');
% fprintf(fid, 'ScenarioEpoch               %s\n',epoch);
% fprintf(fid, 'CoordinateAxes J2000\n');
% fprintf(fid, 'AttitudeTimeQuaternions\n');
% % trueQECI2Body = iaeQuat;
% for i=1:len
%     fprintf(fid,'%e %e %e %e %e\n', t(1,i), ...
%         trueQECI2Body(2,i), trueQECI2Body(3,i), trueQECI2Body(4,i), trueQECI2Body(1,i));
% end
% fprintf(fid, 'END Attitude\n');
% fclose(fid);
