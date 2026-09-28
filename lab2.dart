



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




//10.2
