classdef ReporterInterface < handle
    %REPORTERINTERFACE
    
    methods (Abstract)
        report(obj, data);
    end
end

