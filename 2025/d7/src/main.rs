use std::{
    env::{Args, args},
    fs::File,
    io::{BufRead, BufReader, Lines},
    path::Path,
};

fn parse_input() -> Lines<BufReader<File>> {
    let mut args: Args = args();
    args.next();
    let path_string: String = args.next().expect("AAAAAAAAA");
    let path: &Path = Path::new(&path_string);
    let file: File = File::open(path).unwrap();
    let lineterator: Lines<BufReader<File>> = BufReader::new(file).lines();
    return lineterator;
}

fn main() {
    let lineterator: Lines<BufReader<File>> = parse_input();
    for (row, line_res) in lineterator.enumerate() {
        let line: String = line_res.unwrap();
        let pairs: Vec<(usize, &str)> = line.match_indices('^').collect::<Vec<_>>();
        if !pairs.is_empty() {
            println!(
                "(row, cols) = ({row}, {:?})",
                pairs.iter().map(|pair| pair.0).collect::<Vec<usize>>()
            )
        }
    }
}
