classdef EMD_sign_test
    %% Significance test for Empirical Mode Decomposition
    
    properties
        imfs = []; trend = []; time = [];         % Input data
        sign = []; psdx = [] ; freq = []; fs = [] % spectral data
        mpsdx= []; mper = [] ;                    % mean spectrum and mean periodicity
    end
    
    
    methods
        
        function self = EMD_sign_test(imf, trend, time)
            %% Class constructor
            %  imf - Intrinsic Mode Functions - (float array dims(m x n))
            %  trend- Residual series         - (float array dims(m))
            %  time - Time array              - (integer or float array dims(m)
            
            %addpath(fullfile('src','spectral'));
            
            warning('off','all')
            self.imfs = imf;                            % Intrinsic Mode Functions
            self.trend = trend;                         % trend or residual term
            self.time = time;                           % time
            
            self.fs = 1/abs(time(2)-time(1));           % cuttoff frequency
            
            n = length(0:self.fs/size(self.imfs,1):self.fs/2);
            
            self.psdx = NaN(n,size(self.imfs,2));       % Spectral density
            self.freq = NaN(n,size(self.imfs,2));       % frequency
            self.mpsdx = NaN(1,size(self.imfs,2));      % mean spectral density
            self.mper = NaN(1,size(self.imfs,2));       % mean periodicity
            self.sign = NaN(1,size(self.imfs,2));       % 0,1,2 significance test no, 95%, 99% level
            
            % Computing the significance
            for i = 1:size(self.imfs,2)
                [self.psdx(:,i), self.freq(:,i), ~] = self.FFTPSD(self.imfs(:,i), self.fs);
                [self.mpsdx(i), self.mper(i)] = self.Avg_Spec(self.psdx(:,i)/max(self.psdx(:,i)), self.freq(:,i));
                [self.sign(i)] = self.signf_test(self, size(self.imfs,1), self.mper(i), self.mpsdx(i));
            end
            warning('on','all')
        end
        
    end
    
    methods(Static=true, Access='private')
        
        function [psdx, freq, T] = FFTPSD(data,fs)
            %% Spectral density using FFT algorithm
            %  data - IMF - (float array dim(m))
            %  fs   - Nyquist frequency - (float)
            %
            %  psdx - Spectral density estimate - (array dim(m/2))
            %  freq - frequency - (array dim(m/2))
            %  T    - periodicity - (array dim(m/2))
            
            N = length(data);
            xdft = fft(zscore(data));          % fast fourier transform
            xdft = xdft(1:N/2+1);              
            psdx = (1/(fs*N))*abs(xdft).^2;    
            psdx(2:end-1) = 2*psdx(2:end-1);
            freq = 0:fs/length(data):fs/2;
            freq = freq/fs;
            T = 1./freq;
        end
        
        function [mpsd, mT] = Avg_Spec(psdx, freq)
            %% Average spectrum
            %  psdx - Spectral density estimate - (array(m))
            %  freq - Frequency - (array(m))
            %
            %  mpsd - Mean spectral density estimate - (float)
            %  mT   - Mean peridicity - (float)
            
            [pks, locs] = findpeaks(psdx);
            mpsd = mean(pks);

            T = 1./freq;           
            mT = sum(T(locs).*pks)/sum(pks);
            
        end
        
        function [sign] = signf_test(other, n, mt, mpsd)
            %% Significance test  
            %  n - length of data - (integer)
            %  mt - periodicity - (float)
            %  mpsd - mean spectral density estimate - (float)
            %  other - class
            %
            %  sign - significance - 0 significant at 99%,
            %                        1 significant at 95%,
            %                        2 no significant
            
            [x, y] = other.return_levels(n);
            pos = dsearchn(x',log(mt)');
            sign = 0;
            if log(mpsd)>y(pos,2) & log(mpsd)<y(pos,4)
                sign = 1;
            elseif log(mpsd)>y(pos,1) & log(mpsd)<y(pos,5)
                sign = 2;
            end
        end
        
    end
    
    
    methods(Static=true, Access='public')
        
        function [x, y] = return_levels(n)
            %% Levels of significance
            %  n - data size - (integer)
            %  
            %  x - periodicity - (array)
            %  y - spectral density - (array)
            
            % Theoretical t-student statistics for 99% and 95%
            k = [-2.326, -0.675, 0, 0.675, 2.326];
            T = 0:10000;
            x = log(T);
            
            for i = 1:length(k)
                y(:,i) = -x + k(i)*sqrt(2/n)*exp(x/2);
            end
        end
        
    end
end