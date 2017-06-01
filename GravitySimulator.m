cc
Initial
GravitySimulation(ttarget,dt,G,r0,X,Y,sizee,m,vx,vy,Fx,Fy)
function M = GravitySimulation(ttarget,dt,G,r0,X,Y,sizee,m,vx,vy,Fx,Fy)
    % 采用积分研究体系外作用力时 制约与实际相差较大的点 使稳定性增加 但仍然无法稳定。。。大约仅能稳定十秒左右;
    % 强行令F < 0.0001 的认为 0 tmd稳定了 也算是靠谱吧
    vidObj = VideoWriter('bbb.avi');
    open(vidObj);
    resMat = [zeros(5,sizee);zeros(sizee - 10,5),ones(sizee - 10),zeros(sizee - 10,5);zeros(5,sizee)];
    i = 0;
    for t=0:dt:ttarget
        [Fxout, Fyout]  = Foutint(X, Y, G, m);
        [Fxin , Fyin]   = Fin(X, Y, G, m, r0);
        Fx              = (Fxin + Fxout) .* resMat;
        Fx              = (abs(Fx) > 2.6121e-05) .* Fx;
        Fy              = (Fyin + Fyout) .* resMat;
        Fy              = (abs(Fy) > 2.6121e-05) .* Fy;
        vx              = vx + Fx .* dt ./ m;
        vy              = vy + Fy .* dt ./ m;
        % 检查球之间的碰撞 并讨论粘性影响
        [vx, vy] = PosCheck(vx, vy, X, Y, r0, m);
        vx = vx .* resMat;
        vy = vy .* resMat;
        X               = X + vx.*dt;
        Y               = Y + vy.*dt;
        % 与器壁碰撞 如有点逸散到空间中 则那他妈就不准了
        X               = (X < -sizee/2) .* (X + 2.*(-sizee/2-X)) + (X > sizee/2) .* (X - 2.*(X - sizee/2)) + X .* (X <= sizee/2) .* (X >= -sizee/2);
        Y               = (Y < -sizee/2) .* (Y + 2.*(-sizee/2-Y)) + (Y > sizee/2) .* (Y - 2.*(Y - sizee/2)) + Y .* (Y <= sizee/2) .* (Y >= -sizee/2);
        vx              = (X < -sizee/2) .* (-vx) + (X > sizee/2) .* (-vx) + vx.* (X <= sizee/2) .* (X >= -sizee/2);
        vy              = (Y < -sizee/2) .* (-vy) + (Y > sizee/2) .* (-vy) + vy.* (Y <= sizee/2) .* (Y >= -sizee/2);
        plot(X,Y,'r.');axis equal;axis([-15.5,15.5,-15.5,15.5]);
        i = i+1
        M(i) = getframe;
        writeVideo(vidObj,M(i));
    end
    close(vidObj)
end
