use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::path::Path;

fn parse_input(path: &Path) -> (Vec<(u64, u64)>, Vec<u64>) {
    let file: File = File::open(path).unwrap(); // open the file
    let reader: BufReader<File> = BufReader::new(file);
    let linev: Vec<String> = reader.lines().map(|line| line.unwrap()).collect();

    let mut ranges: Vec<(u64, u64)> = Vec::new();
    let mut ids: Vec<u64> = Vec::new();

    for line in linev {
        if line.contains("-") {
            let range: Vec<&str> = line.split('-').collect();
            let (lower, upper): (u64, u64) = (range[0].parse().unwrap(), range[1].parse().unwrap());
            ranges.push((lower, upper));
        } else if !line.contains("-") {
            if let Ok(id) = line.parse::<u64>() {
                ids.push(id);
            }
        }
    }
    return (ranges, ids);
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    let (ranges, ids): (Vec<(u64, u64)>, Vec<u64>) = parse_input(path);
    println!("ranges: {ranges:?}; ids: {ids:?}")
}
