#ifdef COMPILE_X86
#include <stdio.h>
#include <stdlib.h>
#endif

//--------------------- !!! TODO: FILL IN YOUR FILE PATH !!! ------------------------------------------
char read_path[] = "/home/student/yao-archlab-f26/lab1/sample/data.in";
char write_path[] = "/home/student/yao-archlab-f26/lab1/sample/data.out";
//-----------------------------------------------------------------------------------------------------


#define MAXN 128

int N;

struct CP{
    int x, y;
} X[MAXN];

// The given twiddle factor (have multiplied 8192)
struct CP expTable[MAXN]={{8192,0},{8182,-401},{8152,-802},{8103,-1202},{8034,-1598},{7946,-1990},{7839,-2378},{7713,-2759},{7568,-3134},{7405,-3502},{7224,-3861},{7026,-4211},{6811,-4551},{6579,-4879},{6332,-5196},{6069,-5501},{5792,-5792},{5501,-6069},{5196,-6332},{4879,-6579},{4551,-6811},{4211,-7026},{3861,-7224},{3502,-7405},{3134,-7568},{2759,-7713},{2378,-7839},{1990,-7946},{1598,-8034},{1202,-8103},{802,-8152},{401,-8182},{0,-8192},{-401,-8182},{-802,-8152},{-1202,-8103},{-1598,-8034},{-1990,-7946},{-2378,-7839},{-2759,-7713},{-3134,-7568},{-3502,-7405},{-3861,-7224},{-4211,-7026},{-4551,-6811},{-4879,-6579},{-5196,-6332},{-5501,-6069},{-5792,-5792},{-6069,-5501},{-6332,-5196},{-6579,-4879},{-6811,-4551},{-7026,-4211},{-7224,-3861},{-7405,-3502},{-7568,-3134},{-7713,-2759},{-7839,-2378},{-7946,-1990},{-8034,-1598},{-8103,-1202},{-8152,-802},{-8182,-401},{-8192,0},{-8182,401},{-8152,802},{-8103,1202},{-8034,1598},{-7946,1990},{-7839,2378},{-7713,2759},{-7568,3134},{-7405,3502},{-7224,3861},{-7026,4211},{-6811,4551},{-6579,4879},{-6332,5196},{-6069,5501},{-5792,5792},{-5501,6069},{-5196,6332},{-4879,6579},{-4551,6811},{-4211,7026},{-3861,7224},{-3502,7405},{-3134,7568},{-2759,7713},{-2378,7839},{-1990,7946},{-1598,8034},{-1202,8103},{-802,8152},{-401,8182},{0,8192},{401,8182},{802,8152},{1202,8103},{1598,8034},{1990,7946},{2378,7839},{2759,7713},{3134,7568},{3502,7405},{3861,7224},{4211,7026},{4551,6811},{4879,6579},{5196,6332},{5501,6069},{5792,5792},{6069,5501},{6332,5196},{6579,4879},{6811,4551},{7026,4211},{7224,3861},{7405,3502},{7568,3134},{7713,2759},{7839,2378},{7946,1990},{8034,1598},{8103,1202},{8152,802},{8182,401}};

// Function Declaration
void _printf_num(int num);
void _printf_char(char ch);
void data_input();
void data_output();

void dft_transform_impl();

int main(){

    data_input();

    dft_transform_impl();

    data_output();

}


struct CP Y[MAXN];
int mymul(int x, int y){
    int ret = x*y;
    ret /= 8192;
    return ret;
}
int reverse(int x, int l){
    int ret = 0;
    for(int i = 0; i < l; i ++){
        if(x&(1<<i)){
            ret += (1<<(l-i-1));
        }
    }
    return ret;
}

void dft_transform_impl(){

    //--------------------------------------- TODO: FILL IN CODE HERE ---------------------------------------
    int l = 0;
    for(int i = 1; i < N; i <<=1){
        l++;
    }
    for(int i = 0; i < N; i ++){
        int m=reverse(i,l);
        Y[i].x=X[m].x;
        Y[i].y=X[m].y;
    }
	for (int i = 0; i < N; i ++){
		X[i].x=Y[i].x;
		X[i].y=Y[i].y;
	}
    for(int size = 2; size <= N; size <<=1){
        int halfsize=size/2;
        int expTable_step=N/size;
        for(int i = 0; i < N; i += size){
            int twiddle_k=0;
            for(int j = i; j < i+halfsize; j++){
                int x1=X[j].x-(mymul(X[j+halfsize].x, expTable[twiddle_k].x)-mymul(X[j+halfsize].y, expTable[twiddle_k].y));
                int y1=X[j].y-(mymul(X[j+halfsize].x, expTable[twiddle_k].y)+mymul(X[j+halfsize].y, expTable[twiddle_k].x));
                int x2=X[j].x+(mymul(X[j+halfsize].x, expTable[twiddle_k].x)-mymul(X[j+halfsize].y, expTable[twiddle_k].y));
                int y2=X[j].y+(mymul(X[j+halfsize].x, expTable[twiddle_k].y)+mymul(X[j+halfsize].y, expTable[twiddle_k].x));
				X[j+halfsize].x=x1;
				X[j+halfsize].y=y1;
				X[j].x=x2;
				X[j].y=y2;
                twiddle_k+=expTable_step;
            }
        }
    }
    //-------------------------------------------------------------------------------------------------------
}

void data_input(){
    #ifdef COMPILE_X86
        FILE* ifile = fopen(read_path, "r");
        fscanf(ifile, "%d", &N);
        for(int i = 0; i < N; i ++){
            fscanf(ifile, "%d%d", &X[i].x, &X[i].y);
        }
        fclose(ifile);
        

    #else
        __asm__ __volatile__ (
            "li a7, 1024\n\t"
            "li a1, 0\n\t"
            "mv a0, %[path]\n\t"
            "ecall\n\t"
            "mv t3, a0\n\t"
            "li a7, 65\n\t"
            "mv a1, %[Naddr]\n\t"
            "li a2, 1\n\t"
            "ecall\n\t"
            "li a7, 65\n\t"
            "mv a0, t3\n\t"
            "mv a1, %[addr]\n\t"
            "mv a2, %[len]\n\t"
            "ecall\n\t"
            "li a7, 57\n\t"
            "mv a0, t3\n\t"
            "ecall\n\t"
            : 
            : [path]"r"(read_path), [addr]"r"(X), [len]"r"(MAXN*2), [Naddr]"r"(&N)
            : "a0", "a1", "a2", "t3", "a7"
        );

    #endif
}

void data_output(){

    #ifdef COMPILE_X86

        FILE* ofile = fopen(write_path, "w");
        fprintf(ofile, "%d\n", N);
        for(int i = 0; i < N; i ++){
            fprintf(ofile, "%d %d\n", X[i].x, X[i].y);
        }
        fclose(ofile);

    #else
        __asm__ __volatile__ (
            "li a7, 1024\n\t"
            "li a1, 1\n\t"
            "mv a0, %[path]\n\t"
            "ecall\n\t"
            "mv t3, a0\n\t"

            "mv a1, %[Naddr]\n\t"
            "li a2, 1\n\t"
            "li a7, 66\n\t"
            "ecall\n\t"

            "mv t2, %[addr]\n\t"
            "addi t4, zero, 0\n\t"
        "OUTPUT_ONE_LINE: \n\t"
            "mv a0, t3\n\t"
            "mv a1, t2\n\t"
            "li a2, 2\n\t"
            "li a7, 66\n\t"
            "ecall\n\t"

            "addi t2, t2, 8\n\t"
            "addi t4, t4, 1\n\t"
            "blt t4, %[len], OUTPUT_ONE_LINE\n\t"

            "li a7, 57\n\t"
            "mv a0, t3\n\t"
            "ecall\n\t"
            : 
            : [path]"r"(write_path), [addr]"r"(X), [len]"r"(N), [Naddr]"r"(&N)
            : "a0", "a1", "a2", "t3", "a7"
        );
    #endif
}

// you can use this function to print a number for debugging
void _printf_num(int num) {
    // DO NOT MODIFY THIS!!!
#ifdef COMPILE_X86
    printf("%d", num);
#else
    __asm__ __volatile__ (
        "li a7, 1\n\t"
        "mv a0, %[print_num]\n\t"
        "ecall \n\t"
        : /* no output*/
        : [print_num]"r"(num)
        : "a0", "a7"
    );
#endif
}

// you can use this function to print a char for debugging
void _printf_char(char ch) {
    // DO NOT MODIFY THIS!!!
#ifdef COMPILE_X86
    printf("%c", ch);
#else
    __asm__ __volatile__ (
        "li a7, 11\n\t"
        "mv a0, %[print_num]\n\t"
        "ecall \n\t"
        : /* no output*/
        : [print_num]"r"(ch)
        : "a0", "a7"
    );
#endif
}

