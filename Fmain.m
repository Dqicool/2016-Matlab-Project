function [Fx,Fy] = Fmain(X,Y,G,m,r0,ResMat)
    [Fxout, Fyout]  = Foutint(X, Y, G, m);
    [Fxin , Fyin]   = Finnew(X, Y, G, m, r0);
    Fx              = (Fxin + Fxout) .* ResMat;
    Fx              = (abs(Fx) > 2.6121e-05) .* Fx;
    Fy              = (Fyin + Fyout) .* ResMat;
    Fy              = (abs(Fy) > 2.6121e-05) .* Fy;
end

function [Fxout,Fyout] = Foutint(X, Y, G, m)
% 对于体系外质点的影响 可以通过转化到体系内 但是将体系内原本离散的值看成连续 可能引起误差 且注意变号
%t = x - x0
%p = y - y0
%Fxout = -int(int(t/(t^2+p^2)^(3/2),t,t0,t1),p,p0,p1)
%Fyout 将 Fxout 旋转既得
% 采用积分研究体系外作用力时 制约与实际相差较大的点 使稳定性增加 但仍然无法稳定。。。大约仅能稳定十秒左右;
% 强行令F < 0.0001 的认为 0 tmd稳定了 也算是靠谱吧
sizee =41;
    t1 = ( X - sizee/2);
    t0 = (-X - sizee/2);
    p1 = ( sizee/2 - Y);
    p0 = (-sizee/2 - Y);
    Fxout = -G .* m .^ 2 .* (log(p1 + (p1.^2 + t0.^2).^(1/2)) - log(p1 + (p1.^2 + t1.^2).^(1/2)) - ...
    (log(p0 + (p0.^2 + t0.^2).^(1/2)) - log(p0 + (p0.^2 + t1.^2).^(1/2))));
    t1 = ( Y - sizee/2);
    t0 = (-Y - sizee/2);
    p1 = ( sizee/2 - X);
    p0 = (-sizee/2 - X);
    Fyout = -G .* m .^ 2 .* (log(p1 + (p1.^2 + t0.^2).^(1/2)) - log(p1 + (p1.^2 + t1.^2).^(1/2)) - ...
    (log(p0 + (p0.^2 + t0.^2).^(1/2)) - log(p0 + (p0.^2 + t1.^2).^(1/2))));
end

function [Fxin , Fyin ] = Fin(X, Y, G, m, r0)
%对于体系内质点的影响 累加即可
    sizee = 41;
    Fxin    = zeros(sizee);
    Fyin    = zeros(sizee); 
    for ii0 = 1:sizee
        for jj0 = 1:sizee
            for ii = 1:sizee
                for jj = 1:sizee
                    [dfx,dfy] = dfff(X(ii0,jj0), Y(ii0,jj0), X(ii,jj), Y(ii,jj), r0);
                    Fxin(ii0,jj0) = G .* m(ii,jj) .* m(ii0,jj0) .* dfx + Fxin(ii0,jj0);
                    Fyin(ii0,jj0) = G .* m(ii,jj) .* m(ii0,jj0) .* dfy + Fyin(ii0,jj0);
                end
            end
        end
    end
end

function [dfx,dfy] = dfff(X0, Y0, X, Y, r0)
%考虑为粘性碰撞
    rr  = (X - X0).^2 + (Y - Y0).^2;
    if rr > r0^2
        dfx = (X - X0) / rr^(3/2);
        dfy = (Y - Y0) / rr^(3/2);
    else
        dfx = 1000 * (X-X0);
        dfy = 1000 * (Y-Y0);
    end
end

function [Fxin , Fyin ] = Finnew(X, Y, G, m, r0)
    sizee = 41;
    Fxin    = zeros(sizee);
    Fyin    = zeros(sizee); 
    for ii0 = 1:sizee^2
        for ii = ii0+1:sizee^2 
            [dfx,dfy]   = dffff(X(ii0), Y(ii0), X(ii), Y(ii), r0, G, m(ii0), m(ii));
            Fxin(ii0)   = dfx + Fxin(ii0);
            Fyin(ii0)   = dfy + Fyin(ii0);
            Fxin(ii)    = Fxin(ii) - dfx;
            Fyin(ii)    = Fyin(ii) - dfy;
        end
    end
end

function [dfx,dfy] = dffff(X0, Y0, X, Y, r0, G, m0, m)
    rr  = (X - X0).^2 + (Y - Y0).^2;
    if rr > r0^2
        dfx = G .* m .* m0 .* (X - X0) / rr^(3/2);
        dfy = G .* m .* m0 .* (Y - Y0) / rr^(3/2);
    else
        dfx = G * m0 * m * (X-X0) / r0^3;
        dfy = G * m0 * m * (Y-Y0) / r0^3;
    end
end