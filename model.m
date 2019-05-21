classdef model < handle
    properties 
        ind
        signal
        initial_signal
        name
        Fs
    end
    
    events
        signal_changed
    end
    
    methods    
        
        function obj = model(ind)
            obj.ind = ind;
        end
        
        function obj = MyImport(obj, pathname,filename)
            
            if contains(filename, '.txt')
                obj.MyImport_txt(strcat(pathname,filename));
            elseif contains(filename, '.mat') 
                obj.MyImport_mat(strcat(pathname,filename));
            end
            obj.notify('signal_changed');

        end
        function obj = MyImport_mat(obj, filename) 
           [obj.signal,obj.Fs]  =  load(filename, data, fs);
           obj.initial_signal = obj.signal;
        end 
        
        function obj = MyImport_txt(obj, filename) 
           formatSpec = '%f%f%q%[^\n\r]';
           dataArrayTMP = readtable(filename,'Format',formatSpec);
           obj.signal = dataArrayTMP{:,2};
           obj.signal(isnan(obj.signal)) = 0;
           %obj.signal = (obj.signal - mean(obj.signal))/std(obj.signal);
           obj.initial_signal = obj.signal;
           obj.Fs = 5;
        end
         
        function obj = resample_sig(obj,fs)
            obj.initial_signal = resample(obj.initial_signal,fs,obj.Fs);
            obj.Fs = fs;
            obj.notify('signal_changed');
        end
        
        function  obj = resize_sig(obj, start)
            obj.signal = obj.initial_signal(start*obj.Fs+1:end);
            obj.notify('signal_changed');
        end
    end
end


