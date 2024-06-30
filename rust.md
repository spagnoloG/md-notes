# RUST

## Basic cli tools

- `cargo init` ~ create new rust project
- `cargo run` ~ build & run
- `cargo build` ~ just build
- `cargo build --release` ~ minimal release version (optimized)

## Rust basics

### Arrays

```rust
// Arrays are allocated on stack just like in C
pub fn run() {
  let mut numbers: [i32; 5] = [1, 2, 3, 4, 5];

  numbers[2] = 20; // [1, 2, 20, 4, 5]

  println!("Single value: {}", numbers[0]);  // 1

  println!("Array length: {}",numbers.len()); // 5

  // Arrays are stack allocated
  println!("Array occupies {} bytes", std::mem::size_of_val(&numbers)); // 20 bytes

  // Get slice
  let sliced: &[i32] = &numbers[0..2];
  println!("Sliced: {:?}", sliced); // [1, 2]
}
```

### CLI arguments

```rust
use std::env;

pub fn run() {
  let args: Vec<String>  = env::args().collect();
  let command = args[1].clone();
  let name = "spanskiduh";

  println!("Command: {}", command);

  if command == "hello" {
    println!("Hi {}, how are you?", name);
  }
}
```

### Conditionals

```rust
// Conditionals - Used to check the condition of something and act on the result

pub fn run() {
  let age: u8 = 18;
  let check_id: bool = false;
  let knows_person_of_age = true;

  // If / Else
  if age >= 21 && check_id || knows_person_of_age {
    println!("bartender: What would you like to drink?"); // This gets printed
  } else if age < 21 && check_id{
    println!("bartender: Sorry, you have to leave.");
  } else {
    println!("bartender: I'll need to see your ID");
  }

  // Shorthand If (similar to terminary operator)
  let is_of_age = if age >= 21 {true} else {false};
}
```

### Enums

```rust

enum Movement {
  Up,
  Down,
  Left,
  Right
}

fn move_avatar(m: Movement) {
  match m {
    Movement::Up => println!("Avatar moving up"),
    Movement::Down => println!("Avatar moving down"),
    Movement::Left => println!("Avatar moving left"),
    Movement::Right => println!("Avatar moving right"),
  }
}

pub fn run() {
  let avatar1 = Movement::Left;
  let avatar2 = Movement::Up;
  let avatar3 = Movement::Right;
  let avatar4 = Movement::Down;

  move_avatar(avatar1);
  move_avatar(avatar2);
  move_avatar(avatar3);
  move_avatar(avatar4);
}
```

### Functions

```rust
pub fn run() {
  greeting("Hello", "Jane");

  // Bind function values to variables
  let get_sum = add(5, 5);
  println!("Sum: {}", get_sum);

  // Closure
  let n3: i32 = 10;
  let add_nums = |n1: i32, n2: i32 | n1 + n2 + n3;
  println!("C Sum: {}", add_nums(3,3)); // 16
}

fn greeting(greet: &str, name: &str) {
  println!("{} {}, nice to meet you!", greet, name);
}

fn add(n1: i32, n2: i32) -> i32 {
  n1 + n2
}
```

### Loops

```rust
// Loops - Used to iterate until a condition is met

pub fn run(){

  let mut count = 0;

  // Infinite Loop
  loop {
    count += 1;
    println!("Number: {}", count);

    if count == 20 {
      break;
    }
  }

  // While loop (FizzBuzz)
  while count <= 100 {
    if count % 15 == 0 {
      println!("FizzBuzz");
    } else if count % 3 == 0 {
      println!("Fiz");
    } else if count % 5 == 0 {
      println!("Buzz");
    } else {
      println!("{}", count);
    }
    count += 1;
  }

  // For range
  for x in 0..100 {
    if x % 15 == 0 {
      println!("FizzBuzz");
    } else if x % 3 == 0 {
      println!("Fiz");
    } else if x % 5 == 0 {
      println!("Buzz");
    } else {
      println!("{}", x);
    }
  }
}
```

### Pointer references

```rust
// With non-privitieves, if you assign another variable to a piece of data, the
// first varaible will no longer hold that value. You'll need to use a reference
// (&) to point to the resource.

pub fn run() {
  // Primitive array
  let arr1 = [1, 2, 3];
  let arr2 = arr1;

  // Vector
  let vec1 = vec![1, 2, 3];
  let vec2 = &vec1;
  println!("{:?}", (arr1, arr2)); // ([1, 2, 3], [1, 2, 3])
  println!("{:?}", (&vec1, vec2)); // ([1, 2, 3], [1, 2, 3])
}
```

### Format strings

```rust
pub fn run() {
    // Print to console
    println!("Hello from print.rs file");

    println!("{} se uci {}", "Gasper", "rust");

    // Positional args
    println!("{0} is from {1} and {0} likes to {2}", "Gasper", "SLovEniA", "program");

    // Named args
    println!("{name} likes to play {activity}", name = "John", activity = "Tennis");

    // Placeholder traits
    println!("Binary: {:b} Hex: {:x} Octal: {:o}", 10, 10, 10); // Binary: 1010 Hex: a Octal: 12

    // Placeholder for debug trait
    println!("{:?}", (12, true, "hello")); // (12, true, "hello")

    // Basic math
    println!("10 + 10 = {}", 10 + 10);
}
```

### String manipulation

```rust
// Primitve str = Immutable fixed-length string somewhere in memory
// String = Growable, heal-allocated data structure - Use when you need to modify
// or own strign data

pub fn run() {
  let hello = "Hello"; // Primitve
  let mut growale_hello = String::from("Hello "); // Growable

  // Get string length, works for both types
  println!("Length: {}", hello.len());

  // Append, only Growable
  growale_hello.push('W');
  growale_hello.push_str("orld!");

  // Capacity in bytes (work on both)
  println!("Capacity: {}", growale_hello.capacity());

  println!("Is Empty: {}", hello.is_empty());
  println!("Is Empty: {}", growale_hello.is_empty());

  // Substring??
  println!("{} -> Contains 'World' {}", hello, hello.contains("World"));
  println!("{} -> Contains 'World' {}", growale_hello, growale_hello.contains("World"));

  // Replace
  println!("Replace: {}", growale_hello.replace("World", "Bro"));
  println!("Replace: {}", hello.replace("Hello", "Bye"));

  // Loop through string by whitespace
  for word in growale_hello.split_whitespace() {
    println!("{}", word);
  }

  // Create string with predefined capacity
  let mut s = String::with_capacity(10);
  s.push('a');
  s.push('b');
  println!("{}", s); // ab

  // Assertion testing
  assert_eq!(2, s.len());
  assert_eq!(10, s.capacity());
}
```

### Structs

```rust
// Traditional struct
struct Color {
  red: u8,
  green: u8,
  blue: u8,
}

// Tuple struct
struct Color2(u8, u8, u8);

struct Person {
  first_name: String,
  last_name: String
}

impl Person {
  // Construct person
  fn new(first: &str, last: &str) -> Person {
    Person {
      first_name: first.to_string(),
      last_name: last.to_string()
    }
  }

  // Get full name
  fn full_name(&self) -> String {
    format!("{} {}", self.first_name, self.last_name)
  }

  // Set last name
  fn set_last_name(&mut self, last:&str) {
    self.last_name = last.to_string();
  }

  // Name to tuple
  fn to_tuple(self) -> (String, String) {
    (self.first_name, self.last_name)
  }
}

pub fn run() {
  let mut c = Color {
    red: 255,
    green: 0,
    blue: 0
  };

  c.red = 200;
  println!("color: {} {} {}", c.red, c.green, c.blue);

  let mut c2 = Color2(255, 0, 0);

  c2.0 = 200;
  println!("color: {} {} {}", c2.0, c2.1, c2.2);

  let mut p = Person::new("Marry", "Doe");
  println!("Person {} {}", p.first_name, p.last_name);
  p.set_last_name("Doee");
  println!("Person {}", p.full_name());
  println!("Person tuple {:?}", p.to_tuple());
}
```

### Tuples

```rust

// Max 12 elements, diffrent types allowed

pub fn run() {
   let person: (&str, &str, i8) = ("Gasper", "NG", 22);
   println!("{} is from {} and is {}", person.0, person.1, person.2);
}
```

### Types

```rust
pub fn run() {
   // default is "i32"
   let x = 1;

   // default is "f64"
   let y = 2.5;

   // Add explicit type
   let z: i64 = 33213123;

   // Find max size
   println!("Max i32: {}", std::i32::MAX);
   println!("Max i64: {}", std::i64::MAX);

   // Boolean
   let is_active: bool = true;

   // Get boolean from expression
   let is_greater:bool = 10 > 5;

   let a1 = 'a';
   let face = '\u{1F600}';

   println!("{:?}", (x, y, z, is_active, is_greater, a1, face)); // (1, 2.5, 33213123, true, true, 'a', '😀')
}
```

### Variables

```rust
// Variables hold primitive data or references to data
// Variables are immutable by default (u cannot reasign them)
// Rust is a block-scoped language

pub fn run() {
   let name = "Gasper";
   let mut age = 22;
   let mut i_mutate: i128 = 42069;

   println!("My name is {} and I am {}", name, age);

   // Chage vaue
   age = 23;

   // Define constant
   const ID: i32 = 001;

   // Assign multiple vars
   let (my_name, my_age) = ("Gasper", 200);

   let mut i = 0;
   while i < 10 {
      i_mutate = i_mutate + 420;
      println!("Value: {}", i_mutate);
      i = i + 1;
   }
}
```

### Vectors

```rust

// Vectors are resizable arrays stored on a heap
use std::mem;

pub fn run() {
  let mut numbers: Vec<i32> = vec![1, 2, 3, 4, 5];

  // Assign a value
  numbers[2] = 20;
  // Add on to a vector
  numbers.push(5);
  numbers.push(6);

  // Pop off last value
  numbers.pop(); // [1, 2, 20, 4, 5, 5]

  println!("Single value: {}", numbers[0]); // 1

  println!("Vector length: {}",numbers.len()); // 6

  // Vectors are heap allocated
  println!("Vector occupies {} bytes", mem::size_of_val(&numbers)); // 24

  // Get slice
  let sliced: &[i32] = &numbers[0..2];

  println!("Sliced: {:?}", sliced); // Sliced: [1, 2]

  // Loop through vector values
  for x in numbers.iter() {
    println!("Number: {}", x);
  }

  // Loop and mutate values
  for x in numbers.iter_mut() {
    *x *= 2;
  } // [2, 4, 40, 8, 10, 10]
}
```
