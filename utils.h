#ifndef UTILS_H
#define UTILS_H

#include <vector>
#include <algorithm>
#include "Matrix.h"

using namespace std;

Matrix model_matrix(vector<string>& batch) {
	vector<string> unique_vector;
	for (int i = 0; i < batch.size() ; ++i) {
		if (find(unique_vector.begin(), unique_vector.end(), batch[i]) == unique_vector.end())
			unique_vector.push_back(batch[i]);
	}	
	sort(unique_vector.begin(), unique_vector.end());
	Matrix M(batch.size(), unique_vector.size());
	for (int i = 0; i < batch.size() ; ++i) {
		auto it = find(unique_vector.begin(), unique_vector.end(), batch[i]);
		int idx = distance(unique_vector.begin(), it);
		M.value[i][idx] = 1;
	}
	return M;
}

#endif
