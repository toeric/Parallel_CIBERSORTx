#ifndef PARSER_H
#define PARSER_H

#include "Matrix.h"
#include <fstream>

Matrix read_Data(std::string);

inline double string_to_double(std::string s) {
	double result = 0;
	int weight = -1;
	bool dot = false;
	for (int i = 0; i < s.size(); ++i) {
		if (s[i] == '.') { dot = true; }
		else if (!dot) result = 10 * result + (s[i] - '0');
		else { result += pow(10, weight) * (s[i] - '0'); weight -= 1; }
	}
	return result;
}

void split(const char *str, std::vector<double>& result) {
	char c = ' ';
	bool first = true;
	do {
		const char *begin = str;
		while (*str != c && *str)
			str++;
		if (first)
			first = false;
		else
			result.push_back(string_to_double(std::string(begin, str)));
	} while (0 != *str++);
}

Matrix read_Data(std::string file_name) {
	std::vector<std::vector<double>> v;
	std::ifstream ifs;
	ifs.open(file_name, std::ios::in);
	if (!ifs.is_open()) {
		std::cout << "Fail to open bulk data!\n";
	}
	else {
		std::string s;
		std::getline(ifs, s);
		while (getline(ifs, s)) {
			std::vector <double> tmp;
			split(s.c_str(), tmp);
			v.push_back(tmp);
			//std::cout << s << "\n";
		}
	}
	Matrix M(v.size(), v[0].size());
	M.value = v;
	return M;
}

#endif 

