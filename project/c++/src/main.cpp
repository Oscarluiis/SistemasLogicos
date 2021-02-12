#include <iostream>
using namespace std;

int converter(int me, int op){

    if(me == 0){
        return me;
    }

    if(op == 1){
        me = me / 1000;
    }else{
        me = me * 0.00062137;
    }
    return me;
}

int main (){
    
    printf("converter(5000,1) = %d\n", converter(0,1));
    
}