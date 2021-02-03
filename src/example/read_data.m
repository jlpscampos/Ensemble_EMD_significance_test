function [time, serie] = read_data(file)
    %% 
    % This routine reads hdf5 and returns the time series as the pair
    % time, isotopic data.
    %file  - fullpath of the file                 - (str)
    %time  - time array in years                  - (integer or float)
    %serie - array corresponding to isotopic data - (float)
    
    %% Reading data from hdf5 file
    try
        time = h5read(file,'/MC_sym/age');
    catch
        disp(strcat('error reading time from file:',{' '},file));
        return
    end
    
    try 
        serie= h5read(file,'/MC_sym/data');
    catch
        disp(strcat('error reading time from file:',{' '},file));
        return
    end

end