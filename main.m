ind = 9;
clusters_count = 2;

data1 = dlmread('data3.csv', ';');
data = [data1(:, 9) data1(:,14) data1(:, 16:18)];

cols = length(data(1,:));

% data = [data1(:, 2:5) data1(:, 9) data1(:, 10) data1(:, 14) data1(:, 16) data1(:, 17)];
for i=1:cols
    data(:, i) = (data(:, i) - min(data(:, i))) / (max(data(:, i)) - min(data(:, i)));
end



[centers,U] = fcm(data, clusters_count);
maxU = max(U);

index1 = find(U(1, :) == maxU);
index2 = find(U(2, :) == maxU);
% index3 = find(U(3, :) == maxU);

if length(index1) > length(index2)
    tmp = index1;
    index1 = index2;
    index2 = tmp;
end

TP = 0;
FP = 0;
TN = 0;
FN = 0;
for i=1:length(index1)
    if data1(index1(i), 15) == 1
        TP = TP + 1;
    else
        FP = FP + 1;
    end
end
for i=1:length(index2)
    if data1(index2(i), 15) < 0
        TN = TN + 1;
    else
        FN = FN + 1;
    end
end

Acc = (TP + TN) / (TP + TN + FP + FN);
Recall = TP / (TP + FN);
Prec = TP / (TP + FP);
Spec = TN / (FP + TN);
FPR = FP / (FP + TN);

% figure
% for i=1:cols
%     subplot(4, 5, i)
%     hold on
%     plot(data(index1, ind), data(index1, i), '.r', 'MarkerSize', 1, 'LineWidth', 1)
%     plot(data(index2, ind), data(index2, i), '.b', 'MarkerSize', 1, 'LineWidth', 1)
% %     plot(data(index3, ind), data(index3, i), '.g', 'MarkerSize', 1, 'LineWidth', 1)
%     plot(centers(1, ind), centers(1, i), 'xr', 'MarkerSize', 15, 'LineWidth', 3)
%     plot(centers(2, ind), centers(2, i), 'xb', 'MarkerSize', 15, 'LineWidth', 3)
% %     plot(centers(3, ind), centers(3, i), 'xg', 'MarkerSize', 15, 'LineWidth', 3)
%     title(i)
%     hold off
% end
