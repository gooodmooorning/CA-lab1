#include <math.h>
#include <complex>
#include <vector>
#define MAXN 32768

using namespace std;

int N;

complex<double> expTable[MAXN];

int main(){

    scanf("%d", &N);
    freopen("twiddle.txt", "w", stdout);

    for(int i = 0; i < N; i ++){
            expTable[i] = exp(complex<double>(0, -2*M_PI*i/N));
        }

    
    printf("%d\n", N);
    for(int i = 0; i < N; i ++){
        double rr = expTable[i].real()*8192, ii = expTable[i].imag()*8192;
        printf("{%d,%d},", (int)rr, (int)ii);
    }
    return 0;
}
