% fid = fopen('res1.csv','w');
% for i = 1:length(res)
%     fprintf(fid, '%d; ', res{i, 1});
%     fprintf(fid, '%f; %f; %f; %f; %f; %f; %f\n', res{i, 2:end});
% end
% fclose(fid);

ind = 1;
ANSWER_INDEX = 18;
clusters_count = 2;

% data1 = dlmread('./src/transformed/201311-all.txt', ';');
data1 = dlmread('./src/20101121.txt', ';');
%data = [data1(:, 9) data1(:,14) data1(:, 16:17)];
data = data1(:, 1:17);

% data = [data1(:, 1:6) data1(:, 9:10)];
% data = [data1(:, 8)];
cols = length(data(1,:));

for i=1:cols
    data(:, i) = (data(:, i) - min(data(:, i))) / (max(data(:, i)) - min(data(:, i)));
end

% data3 = dlmread('./src/transformed/201211-all.txt', ';');
% data2 = data3(:, 1:17);
% for i=1:cols
%     data2(:, i) = (data2(:, i) - min(data2(:, i))) / (max(data2(:, i)) - min(data2(:, i)));
% end
% out = distfcm(centers, data2);

% tmp_minU = min(out);
% tmp_index1 = find(out(1, :) == tmp_minU);
% tmp_index2 = find(out(2, :) == tmp_minU);

% tmpTP = 0;
% tmpTN = 0;
% tmpFP = 0;
% tmpFN = 0;
% for i=1:length(data2)
%     if out(1, i) < out(2, i) && (data3(i, ANSWER_INDEX) == 1 || data3(i, ANSWER_INDEX) == -2)
%         tmpTP = tmpTP + 1;
%     elseif out(1, i) >= out(2, i) && (data3(i, ANSWER_INDEX) == 1 || data3(i, ANSWER_INDEX) == -2)
%         tmpFP = tmpFP + 1;
%     elseif out(1, i) < out(2, i) && data3(i, ANSWER_INDEX) == -1
%         tmpFN = tmpFN + 1;
%     elseif out(1, i) >= out(2, i) && data3(i, ANSWER_INDEX) == -1
%         tmpTN = tmpTN + 1;
%     end
% end
% RecallTMP = tmpTP / (tmpTP + tmpFN)

%##########################################################################

comb = {};
for i=1:1:17
    comb{end + 1} = nchoosek(1:17, i);
end

res = [];
start_k = 17;
for k=start_k:length(comb)
    start_j = 1;
    if k == 5
        start_j = 357;
    end
    for j=start_j:length(comb{1, k})
        k
        j
        data = data1(:, [comb{1, k}(j, :)]);
    
        [centers, U] = fcm(data, clusters_count);
        maxU = max(U);


        attack_count = 0;
        for i=1:length(data1)
            if data1(i, ANSWER_INDEX) == 1 || data1(i, ANSWER_INDEX) == -2
                attack_count = attack_count + 1;
            end
        end

        rate = attack_count / length(data1)

        % В index1 атаки (предположение)
        index1 = find(U(1, :) == maxU);
        index2 = find(U(2, :) == maxU);

        if rate < 0.5
            if length(index1) > length(index2)
                tmp = index1;
                index1 = index2;
                index2 = tmp;
                tmp = centers(2, :);
                centers(2, :) = centers(1, :);
                centers(1, :) = tmp;
            end
        else
            if length(index1) < length(index2)
                tmp = index1;
                index1 = index2;
                index2 = tmp;
                tmp = centers(1, :);
                centers(2, :) = centers(2, :);
                centers(2, :) = tmp;
            end
        end

        TP = 0;
        FP = 0;
        TN = 0;
        FN = 0;

        mean_tmp = 0;
        count = 0;
        for i=1:length(index1)
            if data1(index1(i), ANSWER_INDEX) == 1 || data1(index1(i), ANSWER_INDEX) == -2
                TP = TP + 1;
                mean_tmp = mean_tmp + maxU(index1(i));
                count = count + 1;
            else
                FP = FP + 1;
            end
        end
        mean_tmp / count
        for i=1:length(index2)
            if data1(index2(i), ANSWER_INDEX) < 0
                TN = TN + 1;
            else
                FN = FN + 1;
            end
        end

        Acc = (TP + TN) / (TP + TN + FP + FN);
        Recall = TP / (TP + FN)
        Prec = TP / (TP + FP);
        Spec = TN / (FP + TN);
        FPR = FP / (FP + TN);

        mean_attack = mean(maxU(index1));
        mean_no_attack = mean(maxU(index2));
        
        res = cat(1, res, {[comb{1, k}(j, :)] Acc Recall Prec Spec FPR mean_attack mean_no_attack});
    end
end

%##########################################################################

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
