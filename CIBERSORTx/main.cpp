#include "doPerm.h"
#include <iostream>
#include <filesystem>

int main() {
	int perm = 1;
	std::string filenameX = "D:\\Course\\Parallel\\Cibersortx\\X.txt";
	std::string filenameY = "D:\\Course\\Parallel\\Cibersortx\\Y.txt";
	Matrix X = read_Data(filenameX);
	Matrix Y = read_Data(filenameY);
	
	std::vector<double> nulldist;
	nulldist = do_Permutation(perm, X, Y);
	system("PAUSE");
	return 0;
}