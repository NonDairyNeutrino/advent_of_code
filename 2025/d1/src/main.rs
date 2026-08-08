use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader, Lines};
use std::path::Path;

const DIALSIZE: i16 = 100;

fn parse_input(path: &Path) -> impl Iterator<Item = i16> {
    let file: File = File::open(path).unwrap(); // open the file
    let lines: Lines<BufReader<File>> = BufReader::new(file).lines(); // iterator to the reader of the lines of the file
    // iterator over the lines but with L replaced with - and R replaced with nothing to be positive
    let rot_strs = lines.map(|line| -> String { line.unwrap().replace("L", "-").replace("R", "") });
    rot_strs.map(|rot_str| -> i16 { rot_str.parse::<i16>().unwrap_or_default() })
}

fn print_dial(dial: i16) {
    println!(
        "Dial at {}",
        (dial % DIALSIZE) + DIALSIZE * i16::from(dial.is_negative())
    );
}

fn main() {
    // open the file
    // read line into buffer
    // replace L with -1 or R with nothing
    // parse into integer
    // only work in raw position, never mod
    // count += abs(div(old_pos + rotation, DIALSIZE) - div(old_pos, DIALSIZE))
    // repeat
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    let roterator = parse_input(path); // iterator over input lines that gives integers
    let mut pre_rot: i16 = 0;
    let mut post_rot: i16 = 50;
    let mut pre_div: i16 = 0;
    let mut post_div: i16 = post_rot.div_euclid(DIALSIZE);
    let mut delta_div: i16 = 0;
    let mut hits: i16 = 0;

    roterator.for_each(|rot| {
        // update dial position
        pre_rot = post_rot;
        post_rot += rot;
        if post_rot.is_negative() {
            println!("DIAL IS NEGATIVE!")
        };
        print_dial(post_rot);
        // update zero hits
        pre_div = pre_rot.div_euclid(DIALSIZE);
        println!("pre_div = {}", pre_div);
        post_div = post_rot.div_euclid(DIALSIZE);
        println!("post_div = {}", post_div);
        delta_div = post_div - pre_div;
        hits += delta_div.abs();
    });
    println!("Final zero count: {}", hits);
}
