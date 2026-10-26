use std::{
    env::args,
    fs::File,
    io::{BufRead, BufReader},
    path::Path,
    process::exit,
};

#[derive(Debug)]
struct Problem {
    args: Vec<u128>,
    op: String,
}

trait Solve {
    fn solve(&self) -> u128;
}

impl Solve for Problem {
    fn solve(&self) -> u128 {
        let arg_iter = self.args.iter();
        match self.op.as_str() {
            "+" => arg_iter.sum(),
            // "-" => self.args[0] - self.args[1..].iter().sum::<u128>(),
            "*" => arg_iter.product(),
            &_ => panic!(),
        }
    }
}

fn parse_input() -> Vec<Problem> {
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
    // println!("lines: {:?}", lines);

    let mut arg_vecs: Vec<Vec<&str>> = lines
        .iter()
        .map(|line| line.split_whitespace().collect::<Vec<&str>>())
        .collect();
    // println!("arg_vecs: {:?}", arg_vecs);

    let ops: Vec<&str> = arg_vecs.pop().unwrap();
    // println!("ops: {ops:?}");

    let items: Vec<Vec<u128>> = arg_vecs
        .iter()
        .map(|av| {
            av.iter()
                .map(|arg: &&str| arg.parse::<u128>().unwrap())
                .collect()
        })
        .collect();
    // println!("items: {:?}", items);

    // allocate Problems
    let nproblems: usize = items[0].len();
    let mut probs: Vec<Problem> = Vec::with_capacity(nproblems);

    for p in 0..nproblems {
        let prob: Problem = Problem {
            args: items.iter().map(|av| av[p]).collect(),
            op: ops[p].to_owned(),
        };
        probs.push(prob);
    }

    return probs;
}

fn main() {
    let probs: Vec<Problem> = parse_input();
    let mut acc: u128 = 0;
    for prob in probs {
        let sol: u128 = prob.solve();
        acc += sol;
        println!("prob: {prob:?}, solution: {sol}, total: {acc}")
    }
}
