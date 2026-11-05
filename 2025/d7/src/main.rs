use std::{
    env::{Args, args},
    fs::{File, copy},
    io::{BufRead, BufReader, Lines, Read},
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

fn create_out() -> File {
    let mut args: Args = args();
    args.next();
    let path_string: String = args.next().expect("AAAAAAAAA");
    let path: &Path = Path::new(&path_string);

    let out_name: &str = "output.txt";
    let _ = copy(path, out_name);
    return File::open(Path::new(out_name)).unwrap();
}

fn find_source(file_string: &String) -> usize {
    let source_pos = file_string
        .match_indices('S')
        .map(|pair| pair.0)
        .next()
        .unwrap();
    return source_pos;
}

fn linear2coords(pos: usize, row_len: usize) -> (usize, usize) {
    let row: usize = pos.div_euclid(row_len);
    let col: usize = pos.rem_euclid(row_len);
    return (row, col);
}

fn coords2linear(row_len: usize, pos: (usize, usize)) -> usize {
    let (row, col): (usize, usize) = pos;
    return row * row_len + col;
}

fn find_splitters(file_string: &String, row_len: usize) -> Vec<(usize, usize)> {
    let splitters: Vec<(usize, usize)> = file_string
        .match_indices('^')
        .map(|pair| linear2coords(pair.0, row_len))
        .collect();
    return splitters;
}

fn find_beams(file_string: &String, row_len: usize) -> Vec<(usize, usize)> {
    let beams: Vec<(usize, usize)> = file_string
        .match_indices('|')
        .map(|pair| linear2coords(pair.0, row_len))
        .collect();
    return beams;
}

fn split_beam(splitter_pos: (usize, usize)) -> ((usize, usize), (usize, usize)) {
    let row: usize = splitter_pos.0 + 1;
    let cols: (usize, usize) = (splitter_pos.1 - 1, splitter_pos.1 + 1);
    return ((row, cols.0), (row, cols.1));
}

fn put_beam(out: &mut String, pos: (usize, usize), row_len: usize) {
    let beam_pos: usize = coords2linear(row_len, pos);
    out.replace_range(beam_pos..(beam_pos + 1), "|");
}

fn split_put_beams(out: &mut String, splitter_pos: (usize, usize), row_len: usize) {
    let (left_beam, right_beam): ((usize, usize), (usize, usize)) = split_beam(splitter_pos);
    put_beam(out, left_beam, row_len);
    put_beam(out, right_beam, row_len);
    return;
}

fn main() {
    let mut out_file: File = create_out(); // create output.txt that's a copy of the input
    let mut out_buff: String = String::new();
    let _ = out_file.read_to_string(&mut out_buff);
    println!("{out_buff}");
    let row_len: usize = out_buff.find('\n').unwrap() + 1;
    // println!("Number of spaces = {row_len}");

    let source_pos: (usize, usize) = linear2coords(find_source(&out_buff), row_len);
    println!("source at = {source_pos:?}");

    let splitters: Vec<(usize, usize)> = find_splitters(&out_buff, row_len);
    // println!("splitters at {splitters:?}");

    put_beam(&mut out_buff, source_pos, row_len);
    println!("{out_buff}");

    let beams: Vec<(usize, usize)> = find_beams(&mut out_buff, row_len);
    // println!("beams = {beams:?}")

    // let lineterator: Lines<BufReader<File>> = parse_input();
    // for (row, line_res) in lineterator.enumerate() {
    //     let line: String = line_res.unwrap();
    //     let pairs: Vec<(usize, &str)> = line.match_indices('^').collect();
    //     if !pairs.is_empty() {
    //         let cols: Vec<usize> = pairs.iter().map(|pair| pair.0).collect();
    //         let splitters: (usize, &Vec<usize>) = (row, &cols);
    //         println!("splitters = {splitters:?}");
    //         let mut beams: Vec<usize> =
    //             cols.iter().flat_map(|col| vec![col - 1, col + 1]).collect();
    //         println!("beams = {beams:?}");
    //         beams.dedup(); // beams is naturally sorted
    //         println!("beams_dedup = {beams:?}")
    //     }
    // }
}
