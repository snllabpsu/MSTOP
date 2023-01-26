classdef MeanAll
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
      D1_M3 
      D1_S2
      D1_S3
      D2_M1
      D2_S2
      D2_M3
      D2_S1
      D2_S3
    end
    
    methods
%         function [obj1,obj2, obj3,obj4,obj5,obj6,obj7,obj8] = MeanAll(value1,value2,value3,value4,value5,value6,value7,value8)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            function [obj1] = MeanAll(value1)
%function [obj1,obj2,obj3] = MeanAll(value1,value2,value3)
 %function [obj1,obj2] = MeanAll(value1,value2)
 %function [obj1,obj2,obj3,obj4,obj5,obj6] = MeanAll(value1,value2,value3,value4,value5,value6)
            props=properties(obj1);
            
            for i=1:18
                subj=Subject(i);
                 if isempty(subj.D1_M3)
                     for j=1:length(props)
                        obj1.(props{j})(:,i)=nan;
                        % obj2.(props{j})(:,i)=nan;
%                        obj3.(props{j})(:,i)=nan;
%                          obj4.(props{j})(:,i)=nan;
%                          obj5.(props{j})(:,i)=nan;
%                       obj6.(props{j})(i)=0;
                      %obj7.(props{j})(i)=0;
                      
                     end
                 else
                     
                    var1=subj.assign;
                    for j=1:length(props)
                    %     obj1.(props{j})(:,i)=median(var1.(props{j}).(value1),2, 'omitnan');% when there is value in the variable for each time point
                       %  obj2.(props{j})(:,i)=median(var1.(props{j}).(value2),2, 'omitnan'); %check you want median or mean
%                         obj3.(props{j})(:,i)=median(var1.(props{j}).(value3),2, 'omitnan');
                           obj1.(props{j})(1:size(var1.(props{j}).(value1),2),i)=var1.(props{j}).(value1);%when there is value in the variable for each trial
                         %  obj2.(props{j})(1:size(var1.(props{j}).(value2),2),i)=var1.(props{j}).(value2);                         
%                            obj3.(props{j})(1:size(var1.(props{j}).(value3),2),i)=var1.(props{j}).(value3);
%                            obj4.(props{j})(1:size(var1.(props{j}).(value4),2),i)=var1.(props{j}).(value4);
%                            obj5.(props{j})(1:size(var1.(props{j}).(value5),2),i)=var1.(props{j}).(value5);
%                            obj6.(props{j})(1:size(var1.(props{j}).(value6),2),i)=var1.(props{j}).(value6);
%                           obj7.(props{j})(1:size(var1.(props{j}).(value7),2),i)=var1.(props{j}).(value7);
%                           obj7.(props{j})(1:size(var1.(props{j}).(value7),2),i)=var1.(props{j}).(value7);
%                           obj8.(props{j})(1:size(var1.(props{j}).(value8),2),i)=var1.(props{j}).(value8);
                    end
                 end
            end
                
             
        end
        
        
    end
end

