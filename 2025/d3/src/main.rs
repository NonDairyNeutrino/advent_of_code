use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader, Lines, Result};
use std::path::Path;

// find the index and value of the rightmost largest number
fn find_max(v: &Vec<char>) -> (usize, char) {
    let max: char = *(v.iter().max().unwrap());
    let mut max_ind: usize = v.len() + 1;
    for i in (0..v.len()).rev() {
        if v[i] == max {
            max_ind = i;
        }
    }
    return (max_ind, max);
}

fn kernel(charv: Vec<char>, joltage: &mut Vec<char>) {
    let (max_ind, max): (usize, char) = find_max(&charv);
    if charv.is_empty() {
        joltage.push(max);
        kernel(charv[0..max_ind].to_vec(), joltage);
    }
}

fn parse_input(path: &Path) -> impl Iterator<Item = Vec<char>> {
    let file: File = File::open(path).unwrap(); // open the file
    let reader: BufReader<File> = BufReader::new(file);
    let lineterator: Lines<BufReader<File>> = reader.lines();
    let joltagerator = lineterator.map(|line: Result<String>| {
        let charv: Vec<_> = line.unwrap().chars().collect::<Vec<_>>();
        let mut joltage: Vec<char> = Vec::new();
        kernel(charv, &mut joltage);
        return joltage;
    });
    return joltagerator;
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    let mut joltagerator = parse_input(path);
    println!("{:?}", joltagerator.next().unwrap())
}
