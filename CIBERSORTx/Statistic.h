#ifndef STATISTIC_H
#define STATISTIC_H

#include <vector>
#include <numeric>
#include <iostream>

double mean(std::vector<double> yr) {
	double average = std::accumulate(yr.begin(), yr.end(), 0.0) / yr.size();

	return average;
}

double std_deviation(std::vector<double> yr) {
	double variance = 0.0;
	for (auto i = yr.begin(); i != yr.end(); ++i)
		variance += pow(*i - mean(yr), 2);

	return sqrt(variance / yr.size());
}

void standardize(std::vector<double>& yr) {
	//std::cout << mean(yr) << " " << std_deviation(yr) << std::endl;
	for (auto i = yr.begin(); i != yr.end(); ++i)
		*i = (*i - mean(yr)) / std_deviation(yr);
}

#endif
