use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader, Cursor, Result};
use std::path::Path;

fn read_range(reader: &mut BufReader<File>, range_buff: &mut Vec<u8>) -> usize {
    // returns the number of bytes that were placed into the buffer
    let nbytes: usize = reader.read_until(b',', range_buff).unwrap();
    // just to print
    if let Some((_, elements)) = range_buff.split_last() {
        let range_vec: Vec<u8> = elements.to_vec();
        let range_str = String::from_utf8(range_vec).unwrap();
        println!("range: {}", range_str);
    } else {
        println!("Reached end of file");
    };
    return nbytes;
}

fn boundbuff2str(reader: &mut Cursor<Vec<u8>>, bound_buff: &mut Vec<u8>, delim: u8) -> u128 {
    let _: Result<usize> = reader.read_until(delim, bound_buff);
    let bound_vec: Vec<u8> = bound_buff.split_last().unwrap().1.to_vec();
    let bound_str: String = String::from_utf8(bound_vec).unwrap();
    let bound: u128 = bound_str.parse::<u128>().unwrap();
    bound
}

fn read_bounds(range_buff: &Vec<u8>) -> (u128, u128) {
    let mut bound_buff: Vec<u8> = vec![];
    let mut reader: Cursor<Vec<u8>> = Cursor::new(range_buff.clone());

    let lower: u128 = boundbuff2str(&mut reader, &mut bound_buff, b'-');
    println!("lower bound: {}", lower);

    bound_buff.clear(); // clear buffer to effectively replace string instead of append it
    let upper: u128 = boundbuff2str(&mut reader, &mut bound_buff, b',');
    println!("upper bound: {}", upper);

    return (lower, upper);
}

fn parse_input(path: &Path) {
    let file: File = File::open(path).unwrap(); // open the file
    let mut reader: BufReader<File> = BufReader::new(file);
    let mut range_buff: Vec<u8> = vec![];
    while read_range(&mut reader, &mut range_buff) > 0 {
        read_bounds(&range_buff);
        range_buff.clear();
    }
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    parse_input(path); // iterator over input lines that gives integers
}
