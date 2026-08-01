use std::{env::SplitPaths, fs::read_to_string};
use std::io::Result;
use std::str::{FromStr, Split};

struct Rotation {
    dir: char,
    len: u8
}

fn parse_input(path: &str) -> impl Iterator<Item = Rotation> { // add return type
    let input_res: Result<String> = read_to_string(path); // result wrapping file contents
    let rots: Split<'_, char> = input_res.unwrap().split('\n');            // iterator over rotations
    rots.map(
        | rot | -> Rotation {
            let (dir_str, len_str) = rot.split_at(1);
            let dir: char = dir_str.chars().next().unwrap();
            let len: u8   = u8::from_str(len_str).unwrap();
            Rotation { dir: dir, len: len}
        }
    )
}

fn main() {
    const START: u8 = 50;
    const INPUT_PATH: &str = "input.txt";
    let init: parse_input(INPUT_PATH)
}
