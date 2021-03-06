% createJacobian.m
% by Brad Dosch, Alex Htut, Bernardo Olivas, Muhammad Shafawi

function J = createJacobian(x, Y, N, m, PV, pCompFromMismatch, Vswing, thetaSwing)
%{
creates Jacobain matrix
inputs:
    x: column vector of unknowns [theta2,...,theta12,V6,...,V12]
    Y: admittance matrix (NxN)
    N: number of buses in the system
    m: m - 1 = number of PV buses in the system
    PV: values of PV from the generators in the system (2*m - 2)
    pCompFromMismatch: values of computed P values from mismatch.m
    Vswing: voltage at the swing bus (bus 1)
    thetaSwing: angle at the swing bus (bus 1)
outputs:
    J: Jacobian matrix
%}

    % Assign V values.
    % V1 is from swing bus.
    % V2 to V5 are known values from PV buses (renumbered).
    % V6 to V12 are initial values of x.
    V = [Vswing; PV(m : length(PV)); x(N : length(x))];
    
    % theta1 is the only known values from swing bus.
    % theta2 to theta12 are initial values of x.
	theta = [thetaSwing; x(1:(N-1))];
    
    % compute P values from the power flow equations.
    % add filler NaN value to make sure we don't use P1.
    % we calculated pComp in mismatch in createMismatch.m,
    % thus recycle it instead of recomputing it.
	pComp = [NaN; pCompFromMismatch];
    
    % compute Q values from the power flow equations.
    % add filler NaN value to make sure we don't use Q1.
    % we only calculated Q6 to Q12 in mismatch.
    % since we need Q2 to Q12 here, we use the same power flow
    % equation to compute Q values in computeQ.m
	qComp = [NaN; computeQ(Y, N, m, theta, V)];
	
	% J is J_size x J_size matrx  (18x18)
	J_size = 2*N-1-m;
	
    % four quadrants have different sizes
	J11 = zeros(N-1); %11x11
	J12 = zeros(N-1, J_size-N+1); %11x7
	J21 = zeros(J_size-N+1, N-1); %7x11
	J22 = zeros(J_size-N+1, J_size-N+1); %7x7
	
    % The following values for each quadrant are assigned based on
    % the equations from Lecture Note 10
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
