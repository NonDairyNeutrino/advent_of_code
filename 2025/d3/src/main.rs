use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader, Lines, Result};
use std::path::Path;

// find the index and value of the rightmost largest number
fn find_max(v: &Vec<char>) -> Option<(usize, char)> {
    let max: char;
    if let Some(x) = v.iter().max() {
        max = *x;
    } else {
        return None;
    }
    let mut max_ind: usize = v.len() + 1;
    for i in (0..v.len()).rev() {
        if v[i] == max {
            max_ind = i;
        }
    }
    return Some((max_ind, max));
}

fn kernel(charv: Vec<char>, joltage: &mut Vec<char>) {
    println!("charv: {:?}, joltage: {:?}", charv, joltage);
    if let Some((max_ind, max)) = find_max(&charv) {
        if !charv.is_empty() {
            joltage.push(max);
            // only consider the digits to the left
            if joltage[0] == '9' && max_ind != (charv.len() - 1) {
                kernel(charv[(max_ind + 1)..].to_vec(), joltage);
            } else {
                kernel(charv[..max_ind].to_vec(), joltage);
            }
        }
    }
}

fn parse_input(path: &Path) -> impl Iterator<Item = u128> {
    let file: File = File::open(path).unwrap(); // open the file
    let reader: BufReader<File> = BufReader::new(file);
    let lineterator: Lines<BufReader<File>> = reader.lines();
    let joltagerator = lineterator.map(|line: Result<String>| -> u128 {
        let charv: Vec<_> = line.unwrap().chars().collect::<Vec<_>>();
        let mut joltage: Vec<char> = Vec::new();
        kernel(charv, &mut joltage);
        let joltage_string: String = if joltage[0] == '9' {
            joltage.iter().collect::<String>()
        } else {
            joltage.iter().rev().collect::<String>()
        };
        joltage_string.parse::<u128>().unwrap()
    });
    return joltagerator;
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    let joltagerator = parse_input(path);
    joltagerator.for_each(|j| println!("{:?}", j));
    // println!("{}", joltagerator.sum::<u128>());
}
