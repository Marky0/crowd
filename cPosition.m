classdef cPosition
    %helper class for x y coordinates used to overload operator classes
    %Can be used with vectors only
    %Matrices and arrays will return an error
    
    properties
        x                                                                   % x position
        y                                                                   % y position
    end
    
    methods
        
        function this=cPosition(x,y)                                        %Initialise position class
            this.x=x;
            this.y=y;
        end
        
        function answer=plus(a,b)                                           %overload '+' operator
            answer=cPosition([a.x]+[b.x],[a.y]+[b.y]);
        end
        
        function answer=minus(a,b)
            answer=cPosition([a.x]-[b.x],[a.y]-[b.y]);                      %overload '-' operator
        end
        
        function answer=times(a,b)
            answer=cPosition([a.x].*[b.x],[a.y].*[b.y]);                    %overload '.*' operator
        end
        
        function answer=rdivide(a,b)
            answer=cPosition([a.x].*[b.x],[a.y].*[b.y]);                    %overload './' operator
        end
        
        function answer=gt(a,b)
            answer=cPosition([a.x]>[b.x],[a.y]>[b.y]);                      %overload '>' operator
        end
        
        function answer=lt(a,b)
            answer=cPosition([a.x]<[b.x],[a.y]<[b.y]);                      %overload '<' operator
        end
        
        function answer=le(a,b)
            answer=cPosition([a.x]<=[b.x],[a.y]<=[b.y]);                    %overload '<=' operator
        end
        
        function answer=ge(a,b)
            answer=cPosition([a.x]>=[b.x],[a.y]>=[b.y]);                    %overload '>=' operator
        end
          
        function answer=bound(a,lowerLeft,upperRight)                       %returns the position 'a' constrained within a bounding box 
            answer=(a>lowerLeft).*(a<upperRight).*a+...                     %defined by the positions lowerLeft and upperRight
                   (a<=lowerLeft).*lowerLeft+...
                   (a>=upperRight).*upperRight;
        end
        
        function answer=discard(a,lowerLeft,upperRight)                     %discards any positions in vector 'a' that are not within a bounding box 
                                                                            %defined by the positions lowerLeft and upperRight
            check=(a<lowerLeft)+(a>upperRight);                             %determine which positions are inside bounding box
            answer=a((~check.x)&(~check.y));                                %only return positions inside bounding box
            if isempty(answer)                                              %if all positions are outside bounding box, return orignal positions
                answer=a;
            end
        end
              
        function answer=distance(a,b)                                       %Calculate distance between two positions
            answer=sqrt(([a.x]-[b.x]).^2+([a.y]-[b.y]).^2);
        end
        
        function h=plot(a,color)                                            %plot all positions in vector a on a 2d graph
            h=plot([a.x],[a.y],color);             
        end
        
        function setAxis(lowerLeft,upperRight)                              %sets the current axis limits to a bounding box
            set(gca,'xlim',[lowerLeft.x upperRight.x]);                     %defined by the positions lowerLeft and upperRight
            set(gca,'ylim',[lowerLeft.y upperRight.y]);
        end
        
    end
    
end

