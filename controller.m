classdef controller < handle
    %CONTROLLER : Pattern MVC
    properties
       viewObj
       modelObj1
       modelObj2
       signal_select
       sign_corr
    end
    
    events
        corrcoeff_changed
    end
    
    methods
        function obj = controller(viewObj, modelObj1,modelObj2)
            obj.viewObj = viewObj;
            obj.modelObj1 = modelObj1;
            obj.modelObj2 = modelObj2;
            obj.signal_select=1;
        end
        
        function obj = MyImport(obj, index)

            [filename,pathname] = uigetfile({'*.txt', '*.dta'},'Select the file','select');
             if ~isnumeric(filename) && ~isnumeric(pathname)
                 if index == 1
                    obj.modelObj1.MyImport(pathname,filename);
                 else 
                    obj.modelObj2.MyImport(pathname,filename);
                 end
             end
             
        end
        
        function obj = update_signal(obj, start)
            
            if start < 0
                obj.modelObj1.resize_sig(abs(start));
            else 
                obj.modelObj2.resize_sig(start);
            end
            segment = min(length(obj.modelObj1.signal),length(obj.modelObj2.signal))-1;
            
            R = corrcoef(obj.modelObj1.signal(1:segment),obj.modelObj2.signal(1:segment));
            obj.sign_corr = R(1,2);
            obj.notify('corrcoeff_changed');
        end
        
        function obj = update_fs(obj, Fs)
            obj.modelObj1.resample_sig(Fs);
            obj.modelObj2.resample_sig(Fs);
        end
    end
end

