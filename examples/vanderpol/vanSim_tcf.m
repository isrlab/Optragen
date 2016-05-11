function [f,df] = vanSim_tcf(x,xd,xdd,u)
 
	 f(1,:) = 0.5.*(x.^2 + xd.^2 + u.^2);

	 df(1,:)= 1.0.*x; 
	 df(2,:)= 1.0.*xd; 
	 df(3,:)= zeros(size(xdd)); 
	 df(4,:)= 1.0.*u; 

