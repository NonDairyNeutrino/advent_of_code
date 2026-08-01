use std::fmt::{self, Display};
use std::fs::read_to_string;
// use std::io::Result;
use std::str::{FromStr, Split};

struct Rotation {
    dir: i8,
    len: u8,
}
impl Display for Rotation {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.dir, self.len)
    }
}

fn parse_input(path: &str) -> Vec<Rotation> {
    let input_str: String = read_to_string(path).unwrap();
    let input_split: Split<'_, char> = input_str.split('\n');
    let rot_vec: Vec<Rotation> = input_split
        .map(|rot| -> Rotation {
            let (dir_str, len_str) = rot.split_at(1);
            let dir: i8 = match dir_str.chars().next().unwrap() {
                'L' => -1,
                'R' => 1,
                _ => 0,
            };
            let len: u8 = u8::from_str(len_str).unwrap_or_default();
            Rotation { dir: dir, len: len }
        })
        .collect();
    rot_vec
}

fn main() {
    const START: u8 = 50;
    println!("Starting at {}", START);
    const INPUT_PATH: &str = "input_test.txt";
    let rot_vec: Vec<Rotation> = parse_input(INPUT_PATH);
    println!("Rotations parsed; First rotation is {}", rot_vec[0]);
}
