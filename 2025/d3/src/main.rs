use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader, Lines, Result};
use std::path::Path;

fn parse_input(path: &Path) {
    let file: File = File::open(path).unwrap(); // open the file
    let reader: BufReader<File> = BufReader::new(file);
    let lineterator: Lines<BufReader<File>> = reader.lines();
    let bank = lineterator.map(|line: Result<String>| line.unwrap().chars());
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    parse_input(path);
}
