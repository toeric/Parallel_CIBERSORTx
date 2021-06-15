#ifndef doPerm_H
#define doPerm_H

#include <vector>
#include <iostream>
#include <string>
#include <iterator>
#include <algorithm>
#include <random>
#include <vector>
#include <math.h>
#include <chrono> 
#include "Parser.h"
#include "Statistic.h"


std::vector<double> do_Permutation(const int, Matrix, Matrix);

template<class bidiiter> //FisherGate Shuffle
bidiiter sample(bidiiter begin, bidiiter end, size_t num_random) {
	size_t left = std::distance(begin, end);
	unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
	std::minstd_rand simple_rand;
	simple_rand.seed(seed);
	while (num_random--) {
		bidiiter r = begin;
		std::advance(r, simple_rand() % left);
		std::swap(*begin, *r);
		++begin;
		--left;
	}
	return begin;
}

void as_list(Matrix Y, std::vector<double>& result) {
	for (int i = 0; i < Y.n_col; ++i) {
		for (int j = 0; j < Y.n_row; ++j) {
			result.push_back(Y.value[j][i]);
		}
	}
}





std::vector<double> do_Permutation(const int perm, Matrix X, Matrix Y) {
	int itor = 1;
	std::vector<double> Ylist;
	std::vector<double> Ylist_temp(Ylist.size()), yr;
	as_list(Y, Ylist);
	
	//return Ylist_temp;
	while (itor <= perm) {
		
		Ylist_temp = Ylist;
		sample(Ylist_temp.begin(), Ylist_temp.end(), X.n_row);
		std::vector<double>::iterator start = Ylist_temp.begin() + X.n_row;
		std::vector<double>::iterator end = Ylist_temp.end();
		Ylist_temp.erase(start, end);
		yr = Ylist_temp;
		//std::cout << yr[0] << std::endl;
		standardize(yr);
		
		/*-----------CoreAlg------------*/



		/*------------------------------*/

		itor++;
	}

	return yr; //Temporary output
}



#endif
