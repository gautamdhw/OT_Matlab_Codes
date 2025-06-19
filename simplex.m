cost = [ 2 5 0 0 0 0 ]
a = [ 1 4 1 0 0 ; 3 1 0 1 0 ; 1 1 0 0 1 ]
b = [ 24 ; 21 ; 9 ]
A = [ a b ]
var = { 'x1', 'x2' , 's1' , 's2' , 's3','sol'}
bv = [3 4 5]
zjcj = cost(bv) * A - cost
simplex_table = [ A ; zjcj]
array2table(simplex_table,'VariableNames',var)
RUN=true;
while RUN
    if any(zjcj(1:end-1)<0) % check for negative value
        fprintf('The current BFS is not optimal');
        zc=zjcj(1:end-1);
        [Enter_val, pvt_col] = min(zc);
        if all (A(:,pvt_col)<=0)
            error('LPP is Unbounded');
        else
            sol=A(:,end);
            column=A(:,pvt_col);
            for i=1:size(A,1)
                if column(i)>0
                    ratio(i)=sol(i)./column(i);
                else
                    ratio(i)=inf;
                end
            end
            [leaving_value,pvt_row]=min(ratio);
        end
        bv(pvt_row)=pvt_col; % replaced leaving variable with 
        pvt_key=A(pvt_row,pvt_col);
        A(pvt_row,:)=A(pvt_row,:)./pvt_key;
        %row operation
        for i=1:size(A,1)
            if i~=pvt_row
                A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
            end
        end
        zjcj=cost(bv)*A-cost;
        next_table=[zjcj;A];
        array2table(next_table,'VariableNames',var)

    else
        RUN=false;
        fprintf('The table is optimal \n');
        z=input(' Enter 0 for minimization and 1 for maximization \n');
        if z==0
            Obj_value=-zjcj(end);
        else
            Obj_value=zjcj(end);
        end
        fprintf('The final optimal value is %f \n',Obj_value);
    end
end
