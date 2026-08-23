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

fn dial_pos(dial: i16) -> i16 {
    (dial % DIALSIZE) + DIALSIZE * i16::from(dial.is_negative())
}

fn print_dial(dial: i16) {
    println!("Dial at {}", dial_pos(dial));
}

fn div_rem_euclid(lhs: i16, rhs: i16) -> (i16, i16) {
    let q: i16 = lhs.div_euclid(rhs);
    let r: i16 = lhs.rem_euclid(rhs);
    assert_eq!(lhs, q * rhs + r);
    (q, r)
}

fn nhits(pre_rot: i16, post_rot: i16) -> i16 {
    // there are six cases (zero-equality is mod DIALSIZE)
    // because only the number of hits is being counted and not their direction, pre and
    // post are interchangeable with respect to which is greater
    // 0 < pre < post : hits += qf - qi e.g. 99 -> 101  => hits += 1
    // 0 = pre < post : hits += qf - qi e.g. 100 -> 101 => hits += 0
    // pre < 0 < post : hits += qf - qi e.g. -1 -> 1    => hits += 1
    // pre < 0 = post : hits += 1       e.g. -1 -> 0    => hits += 1
    // pre < post < 0 : hits += qf - qi e.g. -101 -> -99 => hits += 1
    // let (qi, ri) = div_rem_euclid(pre_rot, DIALSIZE);
    // let (qf, rf) = div_rem_euclid(post_rot, DIALSIZE);
    let pre_div = pre_rot.div_euclid(DIALSIZE) + 1 - i16::from(pre_rot.is_negative());
    let post_div = post_rot.div_euclid(DIALSIZE) + 1 - i16::from(post_rot.is_negative());
    let delta_div = post_div - pre_div;
    let hits = if post_rot % DIALSIZE != 0 {
        delta_div
    } else {
        delta_div + 1
    };
    return hits;
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
    let mut hits: i16 = 0;

    roterator.for_each(|rot| {
        // update dial position
        pre_rot = post_rot;
        post_rot += rot;
        println!(
            "{} -> {}, hits = {}",
            pre_rot,
            post_rot,
            nhits(pre_rot, post_rot)
        );
        // println!("Finish: {}");
        // print_dial(post_rot);
        hits += nhits(pre_rot, post_rot)
    });
    println!("Final zero count: {}", hits);
}
