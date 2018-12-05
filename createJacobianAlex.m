function J = createJacobianAlex(x, Y, N, m, PV, f_comp, Vswing, thetaSwing)
    V = [Vswing; PV(m : length(PV)); x(N : length(x))];
	theta = [thetaSwing; x(1:(N-1))];
	pComp = [NaN; f_comp(1: (N-1))];
	qComp = [NaN; computeQ(Y, N, m, theta, V)];
	
	% J is J_size x J_size matrx  (18x18)
	J_size = 2*N-1-m;
	
	J11 = zeros(N-1); %11x11
	J12 = zeros(N-1, J_size-N+1); %11x7
	J21 = zeros(J_size-N+1, N-1); %7x11
	J22 = zeros(J_size-N+1, J_size-N+1); %7x7
	
	% J11 matrix
	for k = 2:N
		for j = 2:N
			if j == k
				J11(k-1,k-1) = -1*qComp(k)-(V(k)^2)*imag(Y(k,k));
            else 
                J11(k-1,j-1) = V(k)*V(j)*(real(Y(k, j))*sin(theta(k)-theta(j))-...
				imag(Y(k,j))*cos(theta(k)-theta(j)));				
			end
		end
	end
	
	% J21 matrix
	for k = m+1:N
		for j = 2:N	
			if j == k
				J21(k-m,j-1) = pComp(k) - real(Y(k,k))*(V(k)^2);
            else
                J21(k-m,j-1) = -1*V(k)*V(j)*(real(Y(k,j))*cos(theta(k)-theta(j))+...
				imag(Y(k,j))*sin(theta(k)-theta(j)));
			end
		end
	end
	
	% J12 matrix
	for k = 2:N
		for j = m+1:N
			if j == k
				J12(k-1,j-m) = pComp(k)/V(k) + real(Y(k,k))*V(k);
            else
                J12(k-1,j-m) = V(k)*(real(Y(k,j))*cos(theta(k)-theta(j))+...
				imag(Y(k,j))*sin(theta(k)-theta(j)));				
			end
		end
	end
	
	% J22 matrix
	for k = m+1:N
		for j = m+1:N
			if j == k
				J22(k-m,k-m) = qComp(k)/V(k) - imag(Y(k,k))*V(k);
            else
                J22(k-m,j-m) = V(k)*(real(Y(k,j))*sin(theta(k)-theta(j))-...
				imag(Y(k,j))*cos(theta(k)-theta(j)));				
			end
		end
	end
	
	J = [J11, J12; J21, J22];
end
