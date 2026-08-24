use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader, Split};
use std::path::Path;

fn parse_input(path: &Path) -> Split<BufReader<File>> {
    let file: File = File::open(path).unwrap(); // open the file
    let reader: BufReader<File> = BufReader::new(file);
    let rangestrerator: Split<BufReader<File>> = reader.split(b',');
    rangestrerator
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    let rangestrerator = parse_input(path); // iterator over input lines that gives integers
    // let mut buffer = String::new();
    for rangestr in rangestrerator {
        let str: String = String::from_utf8(rangestr.unwrap()).unwrap();
        println!("{}", str);
    }
}
