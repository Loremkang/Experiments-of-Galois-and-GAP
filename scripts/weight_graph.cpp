#include <cstdio>
#include <cmath>

using namespace std;

int n, m, trash, dst, maxdeg = 0;
int* degree;
int* weights, cnt = 0;

int main() {
	freopen("/ssd0/", "r", stdin);
	freopen("/ssd1/", "w", stdout);
	scanf("%d%d", &n, &m);
	scanf("%d", &trash);
	printf("%d %d\n%d\n", n, m, trash);
	degree = new int[n];
	weights = new int[n];
	for (int i = 0; i < n - 1; i ++) {
		scanf("%d", &degree[i]);
		printf("%d\n", degree[i]);
	}
	degree[n - 1] = m;
	for (int i = n - 1; i >= 1; i ++) {
		degree[i] -= degree[i - 1];
		maxdeg = max(maxdeg, degree[i]);
	}
	for (int i = 0; i < n; i ++) {
		for (int j = 0; j < degree[i]; j ++) {
			scanf("%d", &dst);
			printf("%d\n", dst);
			weights[cnt ++] = ceil(log((2 * maxdeg + 1) / (degree[i] + degree[j] + 1)));
		}
	}
	for (int i = 0; i < cnt; i ++) {
		printf("%d\n", weights[i]);
	}
	delete degree;
	delete weights;
}