use std::fs::File;
use std::io::{BufRead, BufReader, Lines};
use std::path::Path;

fn parse_input(path: &Path) -> impl Iterator<Item = i8> {
    let file: File = File::open(path).unwrap(); // open the file
    let lines: Lines<BufReader<File>> = BufReader::new(file).lines(); // iterator to the reader of the lines of the file
    // iterator over the lines but with L replaced with - and R replaced with nothing to be positive
    let rot_strs = lines.map(|line| -> String { line.unwrap().replace("L", "-").replace("R", "") });
    rot_strs.map(|rot_str| -> i8 { rot_str.parse::<i8>().unwrap() })
}

fn main() {
    // open the file
    // read line into buffer
    // replace L with -1 or R with nothing
    // parse into integer
    // add to accumulator
    // if accumulator is zero, incrememnt counter
    // repeat
    let path: &Path = Path::new("input_test.txt");
    let roterator = parse_input(path); // iterator over input lines that gives integers
    let mut dial: i8 = 50;
    let mut accumulator: i8 = 0;
    println!("Dial at {}", dial);
    roterator.for_each(|rot| {
        dial = (dial + rot) % 100;
        if 0 == dial {
            accumulator += 1;
        }
        println!("Dial at {}; Hit zero {} times", dial, accumulator);
    });
    println!("Final dial: {}; Final zero count: {}", dial, accumulator)
    // roterator.for_each(|rot| println!("Line: {}", rot));
}
