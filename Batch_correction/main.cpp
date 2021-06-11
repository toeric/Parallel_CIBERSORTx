#include <string>
#include <armadillo>
#include "ComBat.h"

//using Matrix = arma::Mat<double>;

int main() {
	Matrix M;
	std::string bulk = "bulk.txt", batch = "batch.txt"; 
	M = ComBat(bulk, batch);
	M.save("A.txt", arma::arma_ascii);
	return 0;
}
