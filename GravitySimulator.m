cc
Initial
M = GravitySimulation(dt,G,r0,X,Y,sizee,m,vx,vy,ResMat);

function M = GravitySimulation(dt,G,r0,X,Y,sizee,m,vx,vy,ResMat)
    vidObj = VideoWriter('aaa.avi');
    open(vidObj);
%   resMat = [zeros(5,sizee);zeros(sizee - 10,5),ones(sizee - 10),zeros(sizee - 10,5);zeros(5,sizee)];
    i = 0;
    while 1
        %第一次计算F1
        [Fx1,Fy1]           = Fmain(X,Y,G,m,r0,ResMat);
        %第一次无需考虑碰撞
        %F->R
        vx1             = vx + Fx1 .* dt ./ m;
        vy1             = vy + Fy1 .* dt ./ m;
        vx1             = vx1 .* ResMat;
        vy1             = vy1 .* ResMat;
        X1             = X + vx.*dt;
        Y1             = Y + vy.*dt;
        [~, ~, X1, Y1]  = EdgeCheck(vx1,vy1,X1,Y1,sizee);
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
        plot(X,Y,'r.');axis equal;axis([-15.5,15.5,-15.5,15.5]);
        i = i+1;
        disp(i);
        M(i) = getframe;
        writeVideo(vidObj,M(i));
    end
end
