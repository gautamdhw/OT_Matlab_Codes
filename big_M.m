% Linear Programming using Big M method for:
% Min. z = 3x1 + 5x2
% S.T. x1 + 3x2 ≥ 3
%      x1 + x2 ≥ 2
%      x1, x2 ≥ 0

clear all
clc

% Set up the initial tableau
% Define coefficient matrix A (constraints)
A = [1 3 -1 0 1 0;
     1 1 0 -1 0 1];
     
% Define the right-hand side vector b
b = [3; 2];

% Define the cost coefficients c
% Adding Big M penalty for artificial variables (M = 1000)
M = 1000;
c = [3 5 0 0 M M];

% Initialize variables for the algorithm
BV = [5 6]; % Initial Basic Variables (artificial variables)
ZC = c - c(BV) * A; % Calculate reduced costs
ZCb = sum(c(BV) .* b); % Initial value of objective function
table = [A b]; % Initial tableau

% Display initial tableau
disp('Initial Tableau:');
array2table(table, 'VariableNames', {'x1', 'x2', 's1', 's2', 'a1', 'a2', 'sol'}, 'RowNames', {'R1', 'R2'})
fprintf('Z row: ');
disp(ZC);
fprintf('Initial objective value: %f\n', ZCb);

% Main simplex algorithm loop
run = true;
while run
    if any(ZC(1:end-1) < 0)
        % Find entering variable (most negative reduced cost)
        [minZC, pvtcol] = min(ZC(1:end-1));
        
        % Calculate ratios for minimum ratio test
        sol = table(:, end);
        col = table(:, pvtcol);
        
        % Check if the problem is unbounded
        if all(col <= 0)
            fprintf('Solution is unbounded!\n');
            break;
        else
            % Calculate ratios for minimum ratio test
            ratio = zeros(size(table, 1), 1);
            for i = 1:size(table, 1)
                if col(i) > 0
                    ratio(i) = sol(i) / col(i);
                else
                    ratio(i) = inf;
                end
            end
            
            % Find the pivot row
            [minR, pvtrow] = min(ratio);
            
            % Update the basic variable set
            BV(pvtrow) = pvtcol;
            
            % Pivot operation
            pvtkey = table(pvtrow, pvtcol);
            table(pvtrow, :) = table(pvtrow, :) / pvtkey;
            
            % Row operations to get zeros in pivot column
            for i = 1:size(table, 1)
                if i ~= pvtrow
                    table(i, :) = table(i, :) - table(i, pvtcol) * table(pvtrow, :);
                end
            end
            
            % Update the reduced costs
            ZC = c - c(BV) * table(:, 1:size(c, 2));
            
            % Update the objective value
            ZCb = sum(c(BV) .* table(:, end));
            
            % Display the current tableau
            fprintf('\nIteration:\n');
            array2table(table, 'VariableNames', {'x1', 'x2', 's1', 's2', 'a1', 'a2', 'sol'}, 'RowNames', {'R1', 'R2'})
            fprintf('Z row: ');
            disp(ZC);
            fprintf('Current objective value: %f\n', ZCb);
        end
    else
        run = false;
        fprintf('\nFinal optimal solution has been obtained!\n');
        
        % Extract the solution
        fprintf('Optimal solution:\n');
        for i = 1:2  % Only consider original variables x1, x2
            if any(BV == i)
                row = find(BV == i);
                fprintf('x%d = %f\n', i, table(row, end));
            else
                fprintf('x%d = 0\n', i);
            end
        end
        
        % Calculate objective value correctly by using original cost coefficients
        x1 = 0;
        x2 = 0;
        for i = 1:length(BV)
            if BV(i) == 1
                x1 = table(i, end);
            elseif BV(i) == 2
                x2 = table(i, end);
            end
        end
        objVal = 3*x1 + 5*x2;
        fprintf('Minimum objective value: z = %f\n', objVal);
        break;
    end
end
