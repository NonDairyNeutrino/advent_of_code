use std::fs::File;
use std::io::{BufRead, BufReader, Lines};
use std::path::Path;

fn parse_input(path: &Path) -> impl Iterator<Item = i16> {
    let file: File = File::open(path).unwrap(); // open the file
    let lines: Lines<BufReader<File>> = BufReader::new(file).lines(); // iterator to the reader of the lines of the file
    // iterator over the lines but with L replaced with - and R replaced with nothing to be positive
    let rot_strs = lines.map(|line| -> String { line.unwrap().replace("L", "-").replace("R", "") });
    rot_strs.map(|rot_str| -> i16 { rot_str.parse::<i16>().unwrap_or_default() })
}

fn mod100(x: i16) -> i16 {
    if x < 0 {
        return 100 - (-x % 100);
    } else {
        return x % 100;
    }
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
    let mut dial: i16 = 50;
    let mut accumulator: i16 = 0;
    roterator.for_each(|rot| {
        if dial + rot <= 0 || dial + rot >= 100 {
            // FIX double counts hits and passes
            accumulator += 1;
        }
        println!("dial: {}, rot: {}, acc: {}", dial, rot, accumulator);
        dial = mod100(dial + rot);
    });
    println!("Final dial: {}; Final zero count: {}", dial, accumulator)
}
