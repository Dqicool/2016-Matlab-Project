function [Fxin , Fyin ] = Finnew(X, Y, G, m, r0)
    sizee = 41;
    Fxin    = zeros(sizee);
    Fyin    = zeros(sizee); 
    for ii0 = 1:sizee^2
        for ii = ii0+1:sizee^2 
            [dfx,dfy]   = dfff(X(ii0), Y(ii0), X(ii), Y(ii), r0, G, m(ii0), m(ii));
            Fxin(ii0)   = dfx + Fxin(ii0);
            Fyin(ii0)   = dfy + Fyin(ii0);
            Fxin(ii)    = Fxin(ii) - dfx;
            Fyin(ii)    = Fyin(ii) - dfy;
        end
    end
end

function [dfx,dfy] = dfff(X0, Y0, X, Y, r0, G, m0, m)
    rr  = (X - X0).^2 + (Y - Y0).^2;
    if rr > r0^2
        dfx = G .* m .* m0 .* (X - X0) / rr^(3/2);
        dfy = G .* m .* m0 .* (Y - Y0) / rr^(3/2);
    else
        dfx = 1000 * (X-X0);
        dfy = 1000 * (Y-Y0);
    end
end