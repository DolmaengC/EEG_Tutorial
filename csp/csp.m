function [W, A] = csp(data1, data2)
    % data1: 클래스 1의 데이터 (channels x samples)
    % data2: 클래스 2의 데이터 (channels x samples)
    % W: 변환 행렬
    % A: 고유값

    % 클래스 1과 클래스 2의 공분산 행렬 계산
    C1 = cov(data1');
    C2 = cov(data2');

    % 공분산 행렬의 평균 계산
    C = C1 + C2;

    % 고유값 분해
    [E, D] = eig(C);

    % 정렬
    [~, ind] = sort(diag(D), 'descend');
    E = E(:, ind);

    % Whitening transformation
    P = sqrt(inv(D)) * E';

    % 공분산 행렬의 정규화
    S1 = P * C1 * P';
    S2 = P * C2 * P';

    % S1과 S2의 고유값 분해
    [B, D1] = eig(S1, S1 + S2);

    % 정렬
    [~, ind] = sort(diag(D1), 'descend');
    B = B(:, ind);

    % 변환 행렬 계산
    W = B' * P;
    A = D1(ind, ind);
end
