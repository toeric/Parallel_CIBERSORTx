#include <stdio.h>
#include "utils.h"
#include <iostream>


int main()
{
	Matrix M1(3, 4);
	Matrix M2(4, 2);
	
	int i, j;

	M1.value[0][0] = 1;	M1.value[0][1] = 1;	M1.value[0][2] = 2;	M1.value[0][3] = 3;
	M1.value[1][0] = 2;	M1.value[1][1] = 1; M1.value[1][2] = 2; M1.value[1][3] = 2;
	M1.value[2][0] = 3;	M1.value[2][1] = 5; M1.value[2][2] = 2; M1.value[2][3] = 1;
	
	M2.value[0][0] = 1;	M2.value[0][1] = 4;
	M2.value[1][0] = 2; M2.value[1][1] = 3;
	M2.value[2][0] = 3; M2.value[2][1] = 2;
	M2.value[3][0] = 4; M2.value[3][1] = 1;

	Matrix M3, M4;
	M4 = M1;
	M4.value[0][0] = 2;

	M3 = M4 * M2;

	M1.MaPrint();
	M4.MaPrint();
	M2.MaPrint();
	M3.MaPrint();
	return 0;
}




