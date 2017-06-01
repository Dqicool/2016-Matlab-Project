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