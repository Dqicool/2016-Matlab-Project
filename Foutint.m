function [Fxout,Fyout] = Foutint(X, Y, G, m)
% 对于体系外质点的影响 可以通过转化到体系内 但是将体系内原本离散的值看成连续 可能引起误差 且注意变号
%t = x - x0
%p = y - y0
%Fxout = -int(int(t/(t^2+p^2)^(3/2),t,t0,t1),p,p0,p1)
%Fyout 将 Fxout 旋转既得
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
