#ifndef COMBAT_H
#define COMBAT_H

#include <stdio.h>
#include "parser.h"
#include "utils.h"

Matrix ComBat(string dat, string batch){

	Matrix Bulk, bayesdata(3,3);
	vector<string> Batch;

	Bulk = read_bulk(dat);
	Batch = read_batch(batch);

	Matrix design = model_matrix(Batch);


	return bayesdata;
}

#endif 
