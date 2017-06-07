cc
Initial
M = GravitySimulation(dt,G,r0,X,Y,sizee,m,vx,vy,ResMat,1);

function M = GravitySimulation(dt,G,r0,X,Y,sizee,m,vx,vy,ResMat,ode)
    vidObj = VideoWriter('asd.avi');
    open(vidObj);
    i = 0;
    while 1
        for www = 1:sizee
            R22  = (X - X(www)).^2 + (Y - Y(www)).^2;
            if sum((R22>0.1) .* (R22<0.9)) > 1
                dt = 0.01;
                break;
            else
                dt = 0.1;
            end
        end
        dt
        %第一次计算F1
        [Fx1,Fy1]           = Fmain(X,Y,G,m,r0,ResMat);
        %第一次无需考虑碰撞
        %F->R
        vx1             = vx + Fx1 .* dt ./ m;
        vy1             = vy + Fy1 .* dt ./ m;
        vx1             = vx1 .* ResMat;
        vy1             = vy1 .* ResMat;
        if ode == 1
            [vx1, vy1]  = PosCheck(vx1, vy1, X, Y, r0, m);
        end
        X1              = X + vx.*dt;
        Y1              = Y + vy.*dt;
        [vx1, vy1, X1, Y1]  = EdgeCheck(vx1,vy1,X1,Y1,sizee);
        if ode == 1
            vx = vx1;
            vy = vy1;
            X  = X1;
            Y  = Y1;
        elseif ode == 2
            %利用第一次结果X1Y1计算第二次F2
            [Fx2, Fy2]      = Fmain(X1,Y1,G,m,r0,ResMat);
            %算出二阶龙格库塔F值
            Fx              = (Fx1 + Fx2)./2;
            Fy              = (Fy1 + Fy2)./2;
            %F->R
            vx              = vx + Fx .* dt ./ m;
            vy              = vy + Fy .* dt ./ m;
            [vx, vy]        = PosCheck(vx, vy, X, Y, r0, m);
            vx              = vx .* ResMat;
            vy              = vy .* ResMat;
            X               = X + vx.*dt;
            Y               = Y + vy.*dt;
            [vx, vy, X, Y]  = EdgeCheck(vx,vy,X,Y,sizee);        
        end
        plot(X,Y,'r.');axis equal;%view(3);
        %axis([-15.5,15.5,-15.5,15.5,-10,10]);set(gcf,'color',[0 0 0]/255);axis off
        i = i+1;
        disp(i);
        if i ==1
            pause(2);
        end
        M = getframe;
        writeVideo(vidObj,M);
    end
end
