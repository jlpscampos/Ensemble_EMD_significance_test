classdef EMD_timeseries
    %% 
    % This class computes the Empirical Mode Decomposition and stores
    % relevant data. 
    
    properties
        data = [];          % input data
        imf = {};           % Intrinsic Mode Functions
        residual = {};      % Residual Time Series
        time = [];          % time
        info = {};          % Info about EMD
        sign = {};          % Significance test
    end
    
    
    methods
        
        function self = EMD_timeseries(time, data)
            %% Ensemble Empirical Mode Decomposition Constructor
            %  time - time vector - (integer, float or time object)
            %  data - data array, rows correspond to m observations and
            %  columns correspond to different n simulations - (float m x n )
            
            self.time = time;
            self.data = data;
            
            wbh = waitbar(0,'0%','Name','Ensemble Empirical Mode Decomposition');
            for i = 1:size(data,2)
                
                % Empirical Mode Decomposition
                [self.imf{i}, self.residual{i}, self.info{i}] = emd(data(:,i),'Interpolation','pchip');
                self.sign{i} = EMD_sign_test(self.imf{i}, self.residual{i}, time);
                
                tbh = i/size(data,2);                                  % Waitbar
                waitbar(tbh,wbh,strcat(num2str(tbh*100,'%3.0f'),'%')); % Waitbar
            end
            delete(wbh)
        end
        
    end
    
end