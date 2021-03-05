classdef EMD_timeseries
    %% 
    % This class computes the Empirical Mode Decomposition and stores
    % relevant data.
    %
    % Usage:
    %       EEMD = EMD_timeseries(time, data, 'pchip');
    %       EEMD = EMD_timeseries(tiem, data, 'spline');
    
    properties
        data = [];          % input data
        imf = {};           % Intrinsic Mode Functions
        residual = {};      % Residual Time Series
        time = [];          % time
        info = {};          % Info about EMD
        sign = {};          % Significance test
    end
    
    
    methods
        
        function self = EMD_timeseries(time, data, interp)
            %% Ensemble Empirical Mode Decomposition Constructor
            %  time - time vector - (integer, float or datetime object array)
            %  data - data array, rows correspond to m observations and
            %         columns correspond to different n simulations - (float m x n )
            %  interp - Interpolation method pchip for raw data and spline
            %           for smoothed data;
            %
            %  self - emd object (see properties above)
            
            % Verify time array, supported two types, integer and datetime
            [t, self.time] = self.verify_time(time);
            self.data = data;
            
            % Computing EMD & Significance test
            wbh = waitbar(0,'0%','Name','Ensemble Empirical Mode Decomposition');
            for i = 1:size(data,2)
                
                % Empirical Mode Decomposition
                [self.imf{i}, self.residual{i}, self.info{i}] = ...
                    emd(data(:,i),'Interpolation',interp);
                
                % Significance Test
                self.sign{i} = EMD_sign_test(self.imf{i}, self.residual{i}, t);
                
                tbh = i/size(data,2);                                  % Waitbar
                waitbar(tbh,wbh,strcat(num2str(tbh*100,'%3.0f'),'%')); % Waitbar
            end
            delete(wbh)
        end
        
    end
    
    
    methods(Static=true, Access='private')
        
        function [t, otime] = verify_time(time)
            %% Verify if time array is a float, double, integer or datetime object
            
            if isdatetime(time)
                t = 1:length(time);
            else
                t = time;
            end
            otime = time;
            
        end
        
    end
    
end