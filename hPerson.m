classdef hPerson < handle                                                   %define as handle class so that positions can be automatically updated between people
    
%handle class hPerson.m which simulates all the behaviours of a
%person in a unit size room 0<x<1 and 0<y<1
    
    properties(Constant)
       LL_ROOM=cPosition(0,0);                                              %Define lower left coordinate of room
       UR_ROOM=cPosition(1,1);                                              %Define upper right coordinate of room
    end
    
    properties
        Position=cPosition(0,0);                                            %My position
        hPerson1                                                            %handle class to First person we want to equidistant against
        hPerson2                                                            %handle class to Second person we want to be equidistant against
        id                                                                  %Vector containing [MyID Person1ID Person2ID] (for debugging)
        isStable=0                                                          %Flag that says if Person has reached Equibrium
        vel                                                                 %Maximum distance person can move per time step
        accuracy                                                            %Fractional accuracy when we consider equilibrium has occured
    end
    
    methods
        
        function h=hPerson()                                                %return handle on creation
        end
        
        function My=initialise(My,Position,hPersons,id,vel,accuracy)        %Initialise all properties
            My.Position=Position;
            My.hPerson1=hPersons(1);
            My.hPerson2=hPersons(2);
            My.id=id;
            My.vel=vel;
            My.accuracy=accuracy;
        end
        
        function My=update(My)
            %new position that person needs to move towards to form an
            %equilateral triangle with hPerson1 and hPerson2 given by
            %https://math.stackexchange.com/questions/1216246/determining-the-3rd-vertex-of-an-equilateral-and-right-angled-isoceles-triangle
            new=[cPosition(0.5.*(My.hPerson1.Position.x + My.hPerson2.Position.x + sqrt(3).*(My.hPerson1.Position.y - My.hPerson2.Position.y)),...
                           0.5.*(My.hPerson1.Position.y + My.hPerson2.Position.y - sqrt(3).*(My.hPerson1.Position.x - My.hPerson2.Position.x)))...
                           
                 cPosition(0.5.*(My.hPerson1.Position.x + My.hPerson2.Position.x - sqrt(3).*(My.hPerson1.Position.y - My.hPerson2.Position.y)),...
                           0.5.*(My.hPerson1.Position.y + My.hPerson2.Position.y + sqrt(3).*(My.hPerson1.Position.x - My.hPerson2.Position.x)))];
            
            new=new.discard(My.LL_ROOM,My.UR_ROOM);                         %discard any positions outside the room
            
            rangeToIdeal=My.Position.distance(new);                         %Calculate distance between Me and new ideal position
            partnerRange=new.distance(My.hPerson1.Position);                %Calculate distance between partners (which is my ideal distance between them)
            if (min(rangeToIdeal)./partnerRange)<My.accuracy                %Equilibrium has occured, do not update position
                My.isStable=1;                                              %Person is stable, do not update position
            else
                My.isStable=0;                                              %Person needs to move
                indexTarget=find(rangeToIdeal==min(rangeToIdeal));          %Make target position closest position to me 
            
                ratio=My.vel./min(rangeToIdeal);                            %Calculate Ratio of distance I can move to distance I need to move
                ratio=(ratio>1)+(ratio<1).*ratio;                           %bound 0<ratio<1 so that if I can get to where I need to be then don't overshoot
            
                My.Position=My.Position.*cPosition(1-ratio,1-ratio)+...
                            new(indexTarget(1)).*cPosition(ratio,ratio);    %Update position based upon how fast I can move
            
                My.Position=My.Position.bound(My.LL_ROOM,My.UR_ROOM);       %Make sure I can't leave the room
            end
                       
        end        
    end
        
end

