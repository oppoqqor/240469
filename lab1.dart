// void main(List<String> arguments) {
//   print('Hello, Dart World!');
//   if (arguments.isNotEmpty) {
//     print('Command line arguments passed: ${arguments.join(", ")}');
//   }
// }


//pr 2
// void main(){
//   final name = "Zayn";
//   const id = 240469;
//   var major = "Computer Sciecne";
  
//   print('$name,\n$id,\n$major\n');
// }

//pr 3
// void main(List<String> args) {
//   print('Number of arguments: ${args.length}');
// }

//pr4
// void main(List<String> args){
//   if(args.isEmpty){
//     return;
//   }

//   double sum = 0;


//   for( final arg in args){
//     sum += double.parse(arg);
//   }
//   print('avg: ${sum/args.length}');
// }


//pr5
// void main(List<String> args){
//   if(args.isEmpty || args.length != 2){
//     print('invalid input');
//     return;
//   }
//   print('good');
//   return;
// }


//pr6
import 'dart:io';

// void main(List<String> args){
//   if(args.isEmpty){
//     exitCode = 1;
//     return;
//   }

//   print('sucess');
//   exitCode = 0;
// }


//pr7



// SECTION II. 2 

// void main() {
//   var mutableName = 'Alice';
//   final String birthCity = 'Tashkent';
//   const double pi = 3.14159;
//   late String lazyDescription;
//   lazyDescription = 'Initialized later!';
//   print ('$mutableName born in $birthCity. Math constant: $pi. Status: $lazyDescription');
// }


// pr2
// void main() {
//   int age = 20;
//   double gpa = 3.8;
//   String country = 'Uzbekistan';
//   bool isStudent = true;

//   print('$age, $gpa, $country, $isStudent');
// }


// pr3
// void main() {
//   final date = DateTime.now();
//   const year = 2026;

//   print('Current date: $date');
//   print('Constant year: $year');
// }


// pr4
// void main() {
//   String? name;
//   String country = 'Uzbekistan';

//   print(name ?? 'Unknown');
//   print(country ?? 'Unknown');
// }


// pr6
// void main() {
//   var coordinate = (10, 20, 30);

//   print(coordinate.$1);
//   print(coordinate.$2);
//   print(coordinate.$3);
// }


// SECTION 3 


// pr2
// void main() {
//   int number = -5;

//   if (number > 0) {
//     print('positive');
//   } else if (number < 0) {
//     print('negative');
//   } else {
//     print('zero');
//   }
// }


// pr3
// void main() {
//   int number = 5;
//   int factorial = 1;

//   for (int i = 1; i <= number; i++) {
//     factorial *= i;
//   }

//   print('factorial: $factorial');

//   factorial = 1;
  
//   var numbers = [1,2,3,4,5];

//   for(var num in numbers){
//     factorial *= num;
//   }

//   print('factorial: $factorial');
// }


// pr4
// void main() {
//   int target = 5;
//   int guess = 0;

//   while (true) {
//     print('guess: $guess');

//     if (guess == target) {
//       break;
//     }

//     guess++;
//   }
// }


// pr5
// void main() {
//   bool stop = false;

//   for (int i = 0; i < 5; i++) {
//     for (int j = 0; j < 5; j++) {
//       if (i == 2 && j == 2) {
//         stop = true;
//         break;
//       }

//       if (j == 1) {
//         continue;
//       }

//       print('$i, $j');
//     }
//     if(stop == true){
//       break;
//     }
//   }
// }


// SECTION 4

// pr2
// bool isEven(int n) => n % 2 == 0;

// void main() {
//   print(isEven(4));
//   print(isEven(7));
// }


// pr3
// String formatName(String name, [String prefix = '', String suffix = '']) {
//   return '$prefix$name$suffix';
// }

// void main() {
//   print(formatName('Zayn'));
//   print(formatName('Zayn', 'Mr. ', ' Jr.'));
// }


// pr4
// int transformList(List<int> numbers, int Function(int) transformer) {
//   int sum = 0;

//   for (final number in numbers) {
//     sum += transformer(number);
//   }

//   return sum;
// }

// void main() {
//   var numbers = [1, 2, 3];

//   print(transformList(numbers, (n) => n * 2));
// }


// pr5
// int fibonacci(int n) {
//   if (n <= 1) {
//     return n;
//   }

//   return fibonacci(n - 1) + fibonacci(n - 2);
// }

// void main() {
//   print(fibonacci(6));
// }