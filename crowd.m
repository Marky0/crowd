%Script which simulates a teaming game where a number of people placed
%in a room, pick two others at random, and move to a position
%in the room where they form an equilateral triangle between themselves and
%their two chosen team members.
%
%Uses the handle class hPerson.m which simulates all the behaviours of a
%person in a unit size room 0<x<1 and 0<y<1
%
%Uses the helper class cPosition.m to calculate the positions of each
%person in the room

clear all
close all
clc

accuracy=0.25;                                                              %Fractional accuracy when we consider equilibrium has occured
N=10;                                                                       %Number of people in the room 
maxVel=0.02;                                                                %Maximum walking distance of person in the room per time step
minVel=0.01;                                                                %Maximum walking distance of person in the room per time step
isRandom=1;                                                                 %Flag indicating if we make velocities of people in the room random ?

for i=1:N
    h(i)=hPerson();                                                         %create a person and store their handle
    pos(i)=cPosition(rand(1),rand(1));                                      %define a random starting position for the person in the room
    
    S=setdiff(1:N,i);
    p1(i)=S(randi(N-1,1,1));                                                %choose the 1st partner in the room (making sure they do not choose themselves)
    
    S=setdiff(1:N,[i p1(i)]);   
    p2(i)=S(randi(N-2,1,1));                                                %chose a 2nd partner in the room (making sure they do not choose themselve or p1)        
end


for i=1:N                                                                   %Initialise all people in the room with a random velocity
    velocity=maxVel.*(~isRandom)+isRandom.*(minVel+(maxVel-minVel).*rand(1));
    h(i)=h(i).initialise(pos(i),[h(p1(i)) h(p2(i))],[i p1(i) p2(i)],...
                         velocity,accuracy);
end
                                                  
figure(1)
    
while sum([h.isStable])<N                                                   %loop until all people in the room have stabalised  
    for i=1:N  
       h(i)=h(i).update();
    end
    cla;                                                                    %clear current graph ready for next fram
    axis('equal');
    setAxis(hPerson.LL_ROOM,hPerson.UR_ROOM)                                %set axis limits to room size
    hold on                                                           
    for i=1:N                                                               %plot positions of all people in the room
        if h(i).isStable
            plot(h(i).Position,'g.');                                       %If person not stable plot position in red
        else
            plot(h(i).Position,'r.');                                       %If person stable plot position in green
        end
    end
    title([num2str(sum([h.isStable])) ' are stable'])
    drawnow();
end

title('COMPLETE !')
for i=1:N
    MyPos=h(i).Position;
    p1Pos=h(h(i).id(2)).Position;
    p2Pos=h(h(i).id(3)).Position;
    plot([MyPos p1Pos p2Pos MyPos],'k');                                    %draw lines between all partners 
    text(MyPos.x,MyPos.y,num2str(i));                                        %label position of each person
    disp([num2str(distance(MyPos,p1Pos)) ' : '...                           %display distances between all partners
          num2str(distance(MyPos,p2Pos)) ' : '...
          num2str(distance(p1Pos,p2Pos))]);
end
        


    