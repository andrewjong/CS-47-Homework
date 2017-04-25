#include <stdio.h>
int main(){
	int array_size = 256;
	char text[array_size];
	printf("Enter your text: ");
	fgets(text, array_size, stdin);

	// rotate each index
	for(int i = 0; i < array_size; i++){
		// check between bounds
		if ((text[i] >= 65 && text[i]<= 90) || (text[i] >=97 && text[i] <= 122)){
			// check for wrapping
			if ((text[i] <= 90 && text[i] > 90-13)
					|| ( text[i] <= 122 && text[i] > 122-13) ){
				text[i] -= 26;
			}
			text[i] += 13;
		}
	}
	// print the rotated output
	printf("%s\n",text);

}
