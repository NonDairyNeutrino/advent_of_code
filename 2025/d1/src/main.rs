use std::fmt::{Display, Formatter, Result};
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::path::Path;

fn parse_input(path: &Path) {
    // open the file
    // read line into buffer
    // replace L with -1 or R with nothing
    // parse into integer
    // add to accumulator
    // if accumulator is zero, incrememnt counter
    // repeat
    let file: File = File::open(path).unwrap();
    BufReader::new(file).lines();
    return;
}

fn main() {
    let path: &Path = Path::new("input_test.txt");
    parse_input(path);
}
