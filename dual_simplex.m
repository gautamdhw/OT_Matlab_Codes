clc
clear all

%%inputs
a=[-1,-1,1,0;-4,-1,0,1];
b=[-2;-4];
c=[-5,-6,0,0,0];
A=[a b];
bv=[3 4];
var = { 'x1', 'x2' , 's1' , 's2', 'sol'}
zjcj = c(bv) * A - c
simplex_table = [ A ; zjcj]
array2table(simplex_table,'VariableNames',var)
RUN=true;
while RUN
    sol=A(:,end);
    if any(sol<0) % check for negative value
        fprintf('The current BFS is not optimal\n');
        [leaving_val, pvt_row] = min(sol);
        fprintf('Leaving row %d\n',pvt_row);
            for i=1:size(A,2)-1
                if A(pvt_row,i)<0
                    ratio(i)=abs(zjcj(i)/A(pvt_row,i));
                else
                    ratio(i)=inf;
                end
            end
            [entering_value,pvt_col]=min(ratio);
            fprintf('Entering column %d\n',pvt_col);
            bv(pvt_row)=pvt_col; % replaced leaving variable with 
            pvt_key=A(pvt_row,pvt_col);
        A(pvt_row,:)=A(pvt_row,:)./pvt_key;
        %row operation
        for i=1:size(A,1)
            if i~=pvt_row
                A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
            end
        end
        zjcj=c(bv)*A-c;
        next_table=[zjcj;A];
        array2table(next_table,'VariableNames',var)

    else
        RUN=false;
        fprintf('The table is feasible \n');
        Obj_value=zjcj(end);
        fprintf('The final optimal value is %f \n',Obj_value);
        % Display final values of variables
        final_values = zeros(1, length(c) - 1);
        final_values(bv) = A(:, end)';
        
        fprintf('Final values of variables:\n');
        for i = 1:length(final_values)
            fprintf('%s = %f\n', var{i}, final_values(i));
        end
    end
end
