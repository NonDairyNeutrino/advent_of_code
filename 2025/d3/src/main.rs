use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader, Lines, Result};
use std::path::Path;

fn find_max(v: Vec<char>) -> (usize, char) {
    let max_ref: &char = v.iter().max().unwrap();
    let mut max_ind: usize = v.len() + 1;
    for i in (0..v.len()).rev() {
        if v[i] == *max_ref {
            max_ind = i;
        }
    }
    return (max_ind, *max_ref);
}

fn kernel(charv: Vec<char>) -> String {
    let mut joltage: Vec<char> = Vec::new();
}

fn parse_input(path: &Path) -> impl Iterator<Item = ()> {
    let file: File = File::open(path).unwrap(); // open the file
    let reader: BufReader<File> = BufReader::new(file);
    let lineterator: Lines<BufReader<File>> = reader.lines();
    let mut joltagerator = lineterator.map(|line: Result<String>| {
        let charv: Vec<_> = line.unwrap().chars().collect::<Vec<_>>();
        kernel(charv)
    });
    return joltagerator;
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    let joltagerator = parse_input(path);
    println!("{:?}", joltagerator.next().unwrap())
}
