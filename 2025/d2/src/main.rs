use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader, Cursor, Seek};
use std::path::Path;

fn parse_input(path: &Path) {
    let file: File = File::open(path).unwrap(); // open the file
    let mut reader: BufReader<File> = BufReader::new(file);

    // read a single range into buffer at a time
    let mut rangebuff: Vec<u8> = vec![];
    let _ = reader.read_until(b',', &mut rangebuff);

    let mut cursor: Cursor<Vec<u8>> = Cursor::new(rangebuff);
    let mut boundbuff: Vec<u8> = vec![];

    // then read lower bound into buffer
    let lower = cursor.read_until(b'-', &mut boundbuff);
    let mut bound: u128 = String::from_utf8(boundbuff.split_last().unwrap().1.to_vec())
        .unwrap()
        .parse::<u128>()
        .unwrap();
    println!("{}", bound);

    // move cursor head to the first digit of upper bound
    let _ = cursor
        .seek_relative(i64::from(lower.unwrap()))
        .unwrap()
        .read_until(b',', &mut boundbuff);
    // bound =
    println!(
        "{}",
        String::from_utf8(boundbuff.split_last().unwrap().1.to_vec()).unwrap()
    );
    // .parse::<u128>()
    // .unwrap();
    // println!("{}", bound)
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    parse_input(path); // iterator over input lines that gives integers
}
