use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader, Cursor};
use std::path::Path;

fn read_range(reader: &mut BufReader<File>, buffer: &mut Vec<u8>) -> usize {
    // returns the number of bytes that were placed into the buffer
    reader.read_until(b',', buffer).unwrap()
}

fn parse_input(path: &Path) {
    let file: File = File::open(path).unwrap(); // open the file
    let mut reader: BufReader<File> = BufReader::new(file);

    // read a single range into buffer at a time
    let mut range_buff: Vec<u8> = vec![];
    let mut range_vec: Vec<u8>; // = Vec::new();
    let mut range_str: String; // = String::new();

    while read_range(&mut reader, &mut range_buff) > 0 {
        // just to print
        range_vec = range_buff.split_last().unwrap().1.to_vec();
        range_str = String::from_utf8(range_vec).unwrap();
        println!("range: {}", range_str);

        // make one buffer that will ... hmmm
        let mut boundbuff: Vec<u8> = vec![];
        // need to make a cursor to read the range buffer
        let mut cursor: Cursor<Vec<u8>> = Cursor::new(range_buff.clone());

        // then read lower bound into buffer
        let _: Result<usize, std::io::Error> = cursor.read_until(b'-', &mut boundbuff);
        let mut bound_vec: Vec<u8> = boundbuff.split_last().unwrap().1.to_vec();
        let mut bound_str: String = String::from_utf8(bound_vec).unwrap();
        let mut bound: u128 = bound_str.parse::<u128>().unwrap();
        println!("lower bound: {}", bound);

        boundbuff.clear(); // clear buffer to effectively replace string instead of append it
        let _ = cursor.read_until(b',', &mut boundbuff);
        bound_vec = boundbuff.split_last().unwrap().1.to_vec();
        bound_str = String::from_utf8(bound_vec).unwrap();
        bound = bound_str.parse::<u128>().unwrap();
        println!("upper bound: {}", bound);

        range_buff.clear();
    }
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    parse_input(path); // iterator over input lines that gives integers
}
