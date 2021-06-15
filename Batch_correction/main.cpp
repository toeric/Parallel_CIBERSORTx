#include <string>
#include <armadillo>
#include "ComBat.h"

//using Matrix = arma::Mat<double>;

int main(int agrc, char* argv[]) {
	Matrix M;
	//std::string bulk = "data/sample1/Bulk.txt", batch = "data/sample1/batch.txt"; 
	std::string bulk = argv[1], batch = argv[2]; 
	M = ComBat(bulk, batch);
	M.save("Batch_result.txt", arma::arma_ascii);
	return 0;
}
