#include <stdio.h>
int main(){
	int size;
	printf("Please enter the size of the array: ");
	scanf("%d", &size);
	if (size <= 0) return 0;

	printf("Input size will be %d\n", size);
	int numbers[size];
	for (int i = 0; i < size; i++){
		printf("Enter number %d: ", i + 1);
		int input;
		scanf("%d", &input);
		numbers[i] = input;
	}
	
	int sum = 0;
	int min = numbers[0];
	int max = numbers[0];
	printf("The array is {");
	for(int i = 0; i < size; i++){
		printf("%d", numbers[i]);
		if (i < size-1)printf(", ");

		sum += numbers[i];
		if (numbers[i] < min) min = numbers[i];
		if (numbers[i] > max) max = numbers[i];
	}
	printf("}\n");
	double mean = (double) sum / size;

	printf("Mean: %f\n", mean);
	printf("Min: %d\n", min);
	printf("Max: %d\n", max);
	return 0;
}




