use std::collections::VecDeque;
use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader, Cursor, Result};
use std::path::Path;

fn read_range(reader: &mut BufReader<File>, range_buff: &mut Vec<u8>) -> usize {
    // returns the number of bytes that were placed into the buffer
    let nbytes: usize = reader.read_until(b',', range_buff).unwrap();
    // just to print
    // if let Some((_, elements)) = range_buff.split_last() {
    //     let range_vec: Vec<u8> = elements.to_vec();
    //     let range_str = String::from_utf8(range_vec).unwrap();
    //     println!("range: {}", range_str);
    // } else {
    //     println!("Reached end of file");
    // };
    return nbytes;
}

fn boundbuff2str(reader: &mut Cursor<Vec<u8>>, bound_buff: &mut Vec<u8>, delim: u8) -> u128 {
    let _: Result<usize> = reader.read_until(delim, bound_buff);
    let bound_vec: Vec<u8> = bound_buff.split_last().unwrap().1.to_vec();
    let bound_str: String = String::from_utf8(bound_vec).unwrap();
    // println!("{:?}", bound_str);
    let bound: u128 = bound_str.parse::<u128>().unwrap();
    bound
}

fn read_bounds(range_buff: &Vec<u8>) -> (u128, u128) {
    if range_buff.is_empty() {
        return (0, 0);
    }
    let mut bound_buff: Vec<u8> = vec![];
    let mut reader: Cursor<Vec<u8>> = Cursor::new(range_buff.clone());

    let lower: u128 = boundbuff2str(&mut reader, &mut bound_buff, b'-');
    // println!("lower bound: {}", lower);

    bound_buff.clear(); // clear buffer to effectively replace string instead of append it
    let upper: u128 = boundbuff2str(&mut reader, &mut bound_buff, b',');
    // println!("upper bound: {}", upper);

    return (lower, upper);
}

fn parse_input(path: &Path) -> impl FnMut() -> (u128, u128) {
    let file: File = File::open(path).unwrap(); // open the file
    let mut reader: BufReader<File> = BufReader::new(file);
    let mut range_buff: Vec<u8> = vec![];
    let mut lower: u128 = 0;
    let mut upper: u128 = 0;
    // while read_range(&mut reader, &mut range_buff) > 0 {
    //     (lower, upper) = read_bounds(&range_buff);
    //     range_buff.clear();
    // }
    move || -> (u128, u128) {
        read_range(&mut reader, &mut range_buff);
        (lower, upper) = read_bounds(&range_buff);
        range_buff.clear();
        return (lower, upper);
    }
}

fn get_digits(n: u128) -> Vec<u8> {
    // add 1 because e.g. log10(1000) == 3 but 1000 has 4 digits
    let ndigits: usize = (n.ilog10() + 1) as usize;
    let mut digitv: Vec<u8> = Vec::with_capacity(ndigits as usize);
    let mut digit: u128;
    let mut ntemp: u128 = n;
    for _ in 0..ndigits {
        digit = ntemp % 10;
        digitv.push(digit as u8);
        ntemp = (ntemp - digit) / 10;
    }
    digitv.reverse();
    return digitv;
}

fn is_invalid(n: u128) -> bool {
    let digitv: Vec<u8> = get_digits(n);
    // convert vector of digits to dequeue to be able to pop_front
    let digitq: VecDeque<u8> = VecDeque::with_capacity(digitv.len());
    digitv.iter().for_each(|e| digitq.push_back(*e));
    let mut seq: Vec<u8> = Vec::new();
    let digit: u8;
    // let mid = 0_usize.midpoint(digitv.len());
    // let isvalid: bool = digitv[0..mid] == digitv[mid..];
    // // println!("{} is {}valid", n, if !isvalid { "not " } else { "" });
    // return isvalid;
    digit = digitq.pop_front().unwrap();
    seq.push(digit);
    if seq == digitq[0..(seq.len() + 1)] && digitv.len().is_multiple_of(seq.len()) {
        return true;
    } else {
        // loop
    }
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    let mut get_range = parse_input(path);
    let mut interval: (u128, u128);
    let mut acc: u128 = 0;
    loop {
        interval = get_range();
        if interval == (0, 0) {
            break;
        } else {
            println!("interval: {:?}", interval);
            // println!("lower: {}, upper: {}", interval.0, interval.1);
            println!("{:?}", get_digits(interval.0));
            println!("{:?}", get_digits(interval.1));
            println!("{:?}", is_invalid(interval.0));
            println!("{:?}", is_invalid(interval.1));
            // for n in interval.0..(interval.1 + 1) {
            //     if is_invalid(n) {
            //         // println!("{}", n);
            //         acc += n
            //     }
            // }
        }
    }
    println!("{}", acc)
}
