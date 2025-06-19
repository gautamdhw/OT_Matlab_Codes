syms x1 x2
f1=x1-x2+2*x1^2+2*x1*x2+x2^2
fx=inline(f1)
fobj=@(x) fx(x(:,1),x(:,2))

grad=gradient(f1)
G=inline(grad)
gradx=@(x)G(x(:,1),x(:,2))
H1=hessian(f1)
Hx=inline(H1)
x0=[0 0]
N=5
tol=0.0005
iter=0
x=[]
while norm(gradx(x0))>tol && iter<N
    x=[x;x0]
    S=-gradx(x0)
    H=Hx(x0)
    lam=S'*S./(S'*H*S)
    Xnew=x0 + lam*S'
    x0=Xnew
    iter=iter + 1
end
x0
fprintf('Final point: [%f %f]\n', x0(1), x0(2));
