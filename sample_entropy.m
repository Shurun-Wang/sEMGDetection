function [ c_2, c_3 ] = sample_entropy(series,r,m )
%PHI 此处显示有关此函数的摘要
%   此处显示详细说明
N = length(series);
d = zeros(N, N,'int8');

for i=1:N
    for j=i+1:N
       if abs(series(1,i)-series(1,j))<=r
          d(i,j) = 1; 
       end
    end
end

b_2 = zeros(1,N-m+1,'double');
for i=1:N-m+1
   tmp = 0;
   for j=i:N-m+1
      tmp = tmp + d(i,j) * d(i+1,j+1);
   end
   b_2(1,i) = tmp;
end
c_2 = 2*mean(b_2 / (N - m));

b_3 = zeros(1,N-m,'double');
for i=1:N-m
   tmp = 0;
   for j=i:N-m
      tmp = tmp + d(i,j) * d(i+1,j+1) * d(i+2,j+2);
   end
   b_3(1,i) = tmp;
end
c_3 = 2*mean(b_3 / (N - m - 1));

end

