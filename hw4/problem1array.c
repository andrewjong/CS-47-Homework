#include <stdio.h>
int main(){
	int size;
	printf("Please enter the size of the array: ");
	scanf("%d", &size);
	printf("Input size will be %d\n", size);
	int numbers[size];
	for (int i = 0; i < size; i++){
		printf("Enter number %d: ", i + 1);
		int input;
		scanf("%d", &input);
		numbers[i] = input;
	}
	printf("The array is {");
	for(int i = 0; i < size-1; i++){
		printf("%d, ", numbers[i]);
	}
	printf("%d}\n", numbers[size-1]);
	return 0;
}




