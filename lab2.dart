



// 5.2
/* 
 * to find the area we must use formula AREA = WIDTH * LENGTH;
*/
double calculateAreaRectangle(double width, double length) => width * length;
// fails if either of input is negative.






//5.3
/// A utility class for validating user data.
class DataValidator {
  /// Checks whether an email is valid.
  ///
  /// [email] is the email address to validate.
  ///
  /// Returns `true` if the email is valid.
  ///
  /// Throws [ArgumentError] if the email is empty.
  static bool isValidEmail(String email) {
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }

    return email.contains('@');
  }
}



//5.4

/// **Email validation utility.**
///
/// This class provides:
/// - Email validation
///
/// Example:
/// ```dart
/// bool result = DataValidator.isValidEmail('test@gmail.com');
/// print(result);
/// ```
///
/// The method returns `true` when the data is valid.
class EmailValidator {
  /// Validates an email address.
  static bool isValidEmail(String email) {
    return email.contains('@');
  }
}


//5.5
class Animal {
  /// sound.
  @deprecated
  void makeSound() {
    print("Sound");
  }

  /// new sound.
  void newSound() {
    print("New sound");
  }
}

class Dog extends Animal {
  /// Overrides woof.
  @override
  void makeSound() {
    print("Woof");
  }
}


//5.6

/// Represents a user in the system.
class User {
  /// The user's name.
  final String name;

  /// The user's age.
  final int age;

  /// Creates a [User].
  User(this.name, this.age);

  /// Returns a description of the user.
  String description() {
    return "$name is $age years old";
  }
}

//6.2
class Person{
  String name;
  int age;
  
  Person(this.name, this.age);
}

// void main(){
//   Person example = Person("nameless", 100);
  
//   print(example.name);
//   print(example.age);
// }

//6.3
class PersonWithChecks{
  String name;
  int age;
  
  PersonWithChecks(this.name, this.age)
    : assert(age >= 0 && age <= 100);
}

// void main(){
//   PersonWithChecks per = PersonWithChecks("name", 1000);
  
//   print(per.age);
// }


//6.4

class Singleton {

  Singleton._();

  static final Singleton _instance = Singleton._();

  factory Singleton() {
    return _instance;
  }
}

// void main() {
//   var a = Singleton();
//   var b = Singleton();

//   print(identical(a, b));
// }


// 6.5 

class Person {
  String name;
  int _age;

  Person(this.name, this._age);

  int get age => _age;

  set age(int value) {
    if (value >= 0 && value <= 120) {
      _age = value;
    } else {
      throw ArgumentError("Age must be between 0 and 120");
    }
  }
}


//6.6


class User {
  final String name;
  final int age;

  const User(this.name, this.age);
}

// void main() {
//   const user = User("John", 20);
//
//   print(user.name);
//   print(user.age);
// }


//7.2
enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

// void main(){
//   for(var day in Day.values){
//     print(day);
//   }
// }


//7.5 
// void main() {
//   String input = "monday";
//
//   Day day = Day.values.byName(input);
//
//   print(day);
// }


// 7.3

String getDayName(Day day) {
  return switch (day) {
    Day.monday => "Monday",
    Day.tuesday => "Tuesday",
    Day.wednesday => "Wednesday",
    Day.thursday => "Thursday",
    Day.friday => "Friday",
    Day.saturday => "Saturday",
    Day.sunday => "Sunday",
  };

}
// void main(){
//   for(var day in Day.values){
//     print(getDayName(day));
//   }
// }


//7.4

abstract class Describable {
  String get description;
}

enum Color implements Describable {
  red,
  blue,
  green;

  @override
  String get description => "This is $name";
}

//7.6 

enum Box<T> {
  integer<int>(),
  text<String>();

  const Box();

  static Box<T> fromType<T>() {
    if (T == int) {
      return Box.integer as Box<T>;
    }

    return Box.text as Box<T>;
  }
}

// void main() {
//   print(Box.fromType<int>());
//   print(Box.fromType<String>());
// }



// 8.2 


class Animal{
  
  
  void makeSound(){
    print("animal made sound");
  }
  
}

class Dog extends Animal{
  @override
  makeSound(){
    print("WOOF");
  }
}


// 8.3 


class Vehicle {
  final String brand;

  Vehicle(this.brand);

  void start() => print('$brand starting...');
}


class ElectricCar extends Vehicle {
  final int batteryCapacity;

  ElectricCar(super.brand, this.batteryCapacity);
  
  @override
  void start () {
  super.start ();
  print ('Battery level : $batteryCapacity kWh ');
  }

}



//8.4

class Shape {
  void draw() {
    print("Drawing shape");
  }
}

class Polygon extends Shape {
  void sides() {
    print("Polygon has sides");
  }
}

class Triangle extends Polygon {
  void show() {
    print("This is a triangle");
  }
}

// void main() {
//   Triangle triangle = Triangle();

//   triangle.draw();
//   triangle.sides();
//   triangle.show();
// }


//8.5
abstract class Animal {
  void eat() {
    print("Eating");
  }

  void makeSound();
}

class Dog extends Animal {
  @override
  void makeSound() {
    print("Woof");
  }
}

// void main() {
//   Dog dog = Dog();
//
//   dog.eat();
//   dog.makeSound();
// }


//8.6

final class Person {
  String name;

  Person(this.name);
}

base class Animal {
  void makeSound() {
    print("Sound");
  }
}

base class Dog extends Animal {
  @override
  void makeSound() {
    print("Woof");
  }
}


//9.2

abstract class DBConnector {
  void connect();
}

class MySQLConnector implements DBConnector {
  @override
  void connect() {
    print("Connected to MySQL");
  }
}

// void main() {
//   MySQLConnector db = MySQLConnector();

//   db.connect();
// }



//9.3


mixin Flyable {
  void fly() {
    print("Flying");
  }
}

class Bird with Flyable {
}

// void main() {
//   Bird bird = Bird();

//   bird.fly();
// }



//9.4 

mixin Walker{
  void walk(){
    print("walking");
  }
}

mixin Swimmer{
  void swim(){
    print("swimming");
  }
}


mixin Ducker{
  void fly(){
    print("flying");
  } 
}


class Duck with Walker, Swimmer, Ducker  {
  
}


// void main() {
//   Duck duck = Duck();

//   duck.walk();
//   duck.swim();
//   duck.fly();
// }



//9,5 

class Animal {
  void eat() {
    print("Eating");
  }
}

class Bird extends Animal with Flyable {
}

// void main() {
//   Bird bird = Bird();
//
//   bird.eat();
//   bird.fly();
// }


//9.6


abstract class Printable {
  void printData();
}

class Report implements Printable {
  @override
  void printData() {
    print("Report");
  }
}

mixin PrintableMixin {
  void printData() {
    print("Report");
  }
}

class Document with PrintableMixin {
}

// void main() {
//   Report report = Report();
//   report.printData();
//
//   Document document = Document();
//   document.printData();
// }



// 10.2
abstract class Shape {
  double area();
}

class Circle extends Shape {
  double radius;

  Circle(this.radius);

  @override
  double area() => 3.14 * radius * radius;
}

class Rectangle extends Shape {
  double width;
  double height;

  Rectangle(this.width, this.height);

  @override
  double area() => width * height;
}

// void main() {
//   List<Shape> shapes = [
//     Circle(5),
//     Rectangle(4, 6),
//   ];
//
//   for (var shape in shapes) {
//     print(shape.area());
//   }
// }


// 10.3
class Animal {
  void makeSound() {
    print("Animal sound");
  }
}

class Dog extends Animal {
  @override
  void makeSound() {
    print("Woof");
  }
}

// void main() {
//   Animal animal = Dog();
//
//   if (animal is Dog) {
//     print("animal is a Dog");
//   }
//
//   Dog dog = animal as Dog;
//   dog.makeSound();
// }


// 10.4
class Repository<T> {
  List<T> items = [];

  void add(T item) {
    items.add(item);
  }

  T get(int index) {
    return items[index];
  }
}

// void main() {
//   Repository<String> names = Repository<String>();
//   names.add("John");
//   names.add("Alex");
//
//   print(names.get(0));
//
//   Repository<int> numbers = Repository<int>();
//   numbers.add(10);
//   numbers.add(20);
//
//   print(numbers.get(1));
// }


// 10.5
sealed class Result {}

class Success extends Result {
  final String message;

  Success(this.message);
}

class Failure extends Result {
  final String error;

  Failure(this.error);
}

String handleResult(Result result) {
  return switch (result) {
    Success(:var message) => "Success: $message",
    Failure(:var error) => "Failure: $error",
  };
}

// void main() {
//   print(handleResult(Success("Operation completed")));
//   print(handleResult(Failure("Something went wrong")));
// }


// 10.6
abstract class PaymentStrategy {
  void pay(double amount);
}

class CardPayment implements PaymentStrategy {
  @override
  void pay(double amount) {
    print("Paid $amount by card");
  }
}

class CashPayment implements PaymentStrategy {
  @override
  void pay(double amount) {
    print("Paid $amount in cash");
  }
}

class PaymentContext {
  PaymentStrategy strategy;

  PaymentContext(this.strategy);

  void checkout(double amount) {
    strategy.pay(amount);
  }
}

// void main() {
//   PaymentContext payment = PaymentContext(CardPayment());
//   payment.checkout(100);
//
//   payment.strategy = CashPayment();
//   payment.checkout(50);
// }


// 11.2
Future<String> fetchUserData() async {
  await Future.delayed(const Duration(seconds: 2));

  return "User #1024";
}

// void main() async {
//   String user = await fetchUserData();
//   print(user);
// }


// 11.3
Future<String> task1() async {
  await Future.delayed(const Duration(seconds: 1));
  return "Task 1 completed";
}

Future<String> task2() async {
  await Future.delayed(const Duration(seconds: 2));
  return "Task 2 completed";
}

Future<String> task3() async {
  await Future.delayed(const Duration(seconds: 1));
  return "Task 3 completed";
}

// void main() async {
//   List<String> results = await Future.wait([
//     task1(),
//     task2(),
//     task3(),
//   ]);
//
//   print(results);
// }


// 11.4
import 'dart:async';

Stream<int> timerStream() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
  }
}

// void main() async {
//   StreamSubscription<int>? subscription;
//
//   subscription = timerStream().listen((value) {
//     print(value);
//
//     if (value == 5) {
//       subscription?.cancel();
//     }
//   });
// }


// 11.5
// void main() async {
//   Stream<int> numbers = Stream.fromIterable([1, 2, 2, 3, 4, 4, 5, 6]);
//
//   await numbers
//       .where((number) => number % 2 == 0)
//       .map((number) => number * 2)
//       .distinct()
//       .forEach(print);
// }


// 11.6
Stream<int> numberStream() async* {
  yield 1;
  yield 2;
  throw Exception("Stream error");
}

// void main() async {
//   await for (var number in numberStream().handleError((error) {
//     print("Error: $error");
//   })) {
//     print(number);
//   }
// }


// 12.2
double divide(double a, double b) {
  try {
    if (b == 0) {
      throw UnsupportedError("Cannot divide by zero");
    }

    return a / b;
  } on UnsupportedError catch (e) {
    print("Error: $e");
    return 0;
  }
}

// void main() {
//   print(divide(10, 2));
//   print(divide(10, 0));
// }


// 12.3
void validateInput(String? input) {
  if (input == null || input.isEmpty) {
    throw ArgumentError("Input cannot be empty or null");
  }

  print(input);
}

// void main() {
//   try {
//     validateInput("");
//   } on ArgumentError catch (e) {
//     print(e);
//   }
// }


// 12.4
void checkValue() {
  try {
    throw FormatException("Invalid format");
  } on FormatException catch (e) {
    print("Format error: $e");
  } on ArgumentError catch (e) {
    print("Argument error: $e");
  } catch (e) {
    print("Unknown error: $e");
  }
}

// void main() {
//   checkValue();
// }


// 12.5
void riskyOperation() {
  throw Exception("Something went wrong");
}

// void main() {
//   try {
//     riskyOperation();
//   } catch (e, stackTrace) {
//     print("Error: $e");
//     print("Stack trace: $stackTrace");
//   }
// }


// 12.6
void processData() {
  try {
    throw Exception("Processing failed");
  } catch (e) {
    print("Logging error: $e");
    rethrow;
  }
}

// void main() {
//   try {
//     processData();
//   } catch (e, stackTrace) {
//     print("Caught again: $e");
//     print(stackTrace);
//   }
// }




