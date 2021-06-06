#include <string>
#include "ComBat.h"

int main() {
	Matrix M;
	std::string bulk = "bulk.txt", batch = "batch.txt"; 
	M = ComBat(bulk, batch);
	return 0;
}
