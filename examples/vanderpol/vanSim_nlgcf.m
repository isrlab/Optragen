function [f,df] = vanSim_nlgcf(x,xd,xdd,u)
 
	 f(1,:) = xdd + x - (1-x.^2).*xd-u;

	 df(1,1,:) = 2.*x.*xd + 1; 
	 df(2,1,:) = x.^2 - 1; 
	 df(3,1,:) = 1.*ones(size(xdd)); 
	 df(4,1,:) = -1.*ones(size(u)); 

