use std::fs::File;
use std::io::{BufRead, BufReader, Lines};
use std::path::Path;

fn parse_input(
    path: &Path,
) -> std::iter::Map<Lines<BufReader<File>>, impl FnMut(Result<String, std::io::Error>) -> String> {
    let file: File = File::open(path).unwrap(); // open the file
    let lines: Lines<BufReader<File>> = BufReader::new(file).lines(); // iterator to the reader of the lines of the file
    lines.map(|line| -> String { line.unwrap().replace("L", "-").replace("R", "") })
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
    let lines = parse_input(path);
    lines.for_each(|line| println!("Line: {}", line));
}
