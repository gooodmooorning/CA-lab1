#include <math.h>
#include <complex>
#include <vector>
#define MAXN 32768

using namespace std;

int N;

complex<double> expTable[MAXN];

complex<double> X[MAXN], Y[MAXN];
    


int main(){

    freopen("../sample/data.in", "r", stdin);
    freopen("../sample/force.out", "w", stdout);

    scanf("%d", &N);

    for(int i = 0; i < N; i ++){
        double tmpx, tmpy; scanf("%lf%lf", &tmpx, &tmpy);
        X[i] = complex<double>(tmpx/8192, tmpy/8192);
        Y[i] = complex<double>(0,0);
    }

    for(int i = 0; i < N; i ++){
        for(int j = 0; j < N; j ++){
            Y[i] += X[j]*exp(complex<double>(0, -2*M_PI*i*j/N));
        }
    }

    printf("%d\n", N);
    for(int i = 0; i < N; i ++){
        int tmpr = (int)(Y[i].real()*8192);
        int tmpi = (int)(Y[i].imag()*8192);
        if(tmpr < 0) tmpr += 2147483648;
        if(tmpi < 0) tmpi += 2147483648;
        printf("%d %d\n", tmpr, tmpi);
    }


    return 0;
}
