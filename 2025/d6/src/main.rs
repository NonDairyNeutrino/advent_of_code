use std::{
    env::args,
    fs::File,
    io::{BufRead, BufReader},
    path::Path,
    process::exit,
};

struct Problem {
    args: Vec<u128>,
    op: String,
}

fn parse_input() {
    let args: Vec<String> = args().collect();
    if args.len() == 1 {
        eprintln!("Where's the input dumbass?");
        exit(1);
    }
    let path: &Path = Path::new(&args[1]);
    let file: File = File::open(path).unwrap();

    let lines: Vec<String> = BufReader::new(file)
        .lines()
        .map(|line| line.unwrap())
        .collect();
    println!("lines: {:?}", lines);

    let mut arg_vecs: Vec<Vec<&str>> = lines
        .iter()
        .map(|line| line.split_whitespace().collect::<Vec<&str>>())
        .collect();
    println!("arg_vecs: {:?}", arg_vecs);

    let ops: Vec<&str> = arg_vecs.pop().unwrap();
    println!("ops: {ops:?}");
    let items: Vec<Vec<u128>> = arg_vecs
        .iter()
        .map(|av| {
            av.iter()
                .map(|arg: &&str| arg.parse::<u128>().unwrap())
                .collect()
        })
        .collect();
    println!("items, {:?}", items);

    // allocate Problems
}

fn main() {
    parse_input();
}
