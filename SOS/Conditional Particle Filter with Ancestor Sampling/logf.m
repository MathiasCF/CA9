function out= logf(xn,xp,q,sigw)
out  = xn(2)*log(q)+(1-xn(2))*log(1-q) + (xp(2)==1)*((-0.5*(0.5*xp(1)+0.1-xn(1)).^2/(sigw^2))+log(1/(sigw*sqrt(2*pi)))) + ...
    (xp(2)==0)*((-0.5*(0.5*xp(1)-xn(1)).^2/(sigw^2))+log(1/(sigw*sqrt(2*pi))));
end

