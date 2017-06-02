function [vx,vy,X,Y] = EdgeCheck(vx,vy,X,Y,sizee)
    % 与器壁碰撞 如有点逸散到空间中 则那他妈就不准了
    X               = (X < -sizee/2) .* (X + 2.*(-sizee/2-X)) + (X > sizee/2) .* (X - 2.*(X - sizee/2)) + X .* (X <= sizee/2) .* (X >= -sizee/2);
    Y               = (Y < -sizee/2) .* (Y + 2.*(-sizee/2-Y)) + (Y > sizee/2) .* (Y - 2.*(Y - sizee/2)) + Y .* (Y <= sizee/2) .* (Y >= -sizee/2);
    vx              = (X < -sizee/2) .* (-vx) + (X > sizee/2) .* (-vx) + vx.* (X <= sizee/2) .* (X >= -sizee/2);
    vy              = (Y < -sizee/2) .* (-vy) + (Y > sizee/2) .* (-vy) + vy.* (Y <= sizee/2) .* (Y >= -sizee/2);
end