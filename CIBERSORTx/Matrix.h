#ifndef Matrix_H
#define Matrix_H

#include <stdlib.h>
#include <vector>
#include <iostream>

class Matrix {

	public:
		
		unsigned n_row, n_col;
		std::vector<std::vector<double>> value;

		Matrix(){};

		Matrix(unsigned i, unsigned j) {
			n_row = i;
			n_col = j;
			for (int w = 0; w < i; ++w) {
				value.emplace_back(j, 0);
			}
		}

		Matrix(const Matrix& rhs) {
			n_row = rhs.n_row;
			n_col = rhs.n_col;
			value = rhs.value;
		}

		~Matrix(){};

		Matrix operator*(const Matrix& rhs) {
			Matrix output_m(this->n_row, rhs.n_col);
			for (int i = 0; i < this->n_row; ++i) {
				for (int j = 0; j < rhs.n_col; ++j) {
					for (int k = 0; k < this->n_col; ++k) {
						output_m.value[i][j] += this->value[i][k] * rhs.value[k][j];
					}
				}
			}
			return output_m;
		}

		void MaPrint(void) {
			std::cout << "------------" << std::endl;
			for (int i = 0; i < this->n_row; ++i){
				for (int j = 0; j< this->n_col; ++j){
					std::cout << this->value[i][j] << " ";
				}
				std::cout <<  std::endl;
			}
			std::cout << "------------" << std::endl;
		}

};

#endif    
