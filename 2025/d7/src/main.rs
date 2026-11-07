use std::{
    env::{Args, args},
    fs::{File, copy},
    io::Read,
    path::Path,
};

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

fn extend_beam(beam_pos: (usize, usize)) -> (usize, usize) {
    return (beam_pos.0 + 1, beam_pos.1);
}

fn put_beam(out: &mut String, pos: (usize, usize), row_len: usize) {
    let beam_pos: usize = coords2linear(row_len, pos);
    if beam_pos < out.len() {
        out.replace_range(beam_pos..(beam_pos + 1), "|");
    }
}

fn will_split(splitters: &Vec<(usize, usize)>, beam_pos: (usize, usize), acc: &mut u64) -> bool {
    let will: bool = splitters.contains(&(beam_pos.0 + 1, beam_pos.1));
    if will {
        *acc += 1;
    }
    return will;
}

fn split_beam_recursive(
    out: &mut String,
    row_len: usize,
    splitters: &Vec<(usize, usize)>,
    beams: &mut Vec<(usize, usize)>,
    mut acc: &mut u64,
) {
    // let beams: Vec<(usize, usize)> = find_beams(&mut out, row_len);
    let mut new_beams: Vec<(usize, usize)> = Vec::new();

    for beam in beams.into_iter() {
        if will_split(&splitters, *beam, &mut acc) {
            let splitter: (usize, usize) = (beam.0 + 1, beam.1);
            let (left_beam, right_beam): ((usize, usize), (usize, usize)) = split_beam(splitter);
            println!("splitting {beam:?} into {left_beam:?} and {right_beam:?}; splits = {acc}");

            if !new_beams.contains(&left_beam) {
                new_beams.push(left_beam);
                put_beam(out, left_beam, row_len);
            }
            if !new_beams.contains(&right_beam) {
                new_beams.push(right_beam);
                put_beam(out, right_beam, row_len);
            }
        } else {
            let extended_beam: (usize, usize) = extend_beam(*beam);
            if coords2linear(row_len, extended_beam) < out.len() {
                println!("extending {beam:?} to {extended_beam:?}");
                if !new_beams.contains(&extended_beam) {
                    new_beams.push(extended_beam);
                    put_beam(out, extended_beam, row_len);
                }
            }
        }
    }

    if new_beams.is_empty() {
        return;
    } else {
        println!("new beams = {new_beams:?}");
        split_beam_recursive(out, row_len, splitters, &mut new_beams, &mut acc);
    }
}

fn main() {
    let mut out_file: File = create_out(); // create output.txt that's a copy of the input
    let mut out_buff: String = String::new();
    let _ = out_file.read_to_string(&mut out_buff);
    println!("before");
    println!("{out_buff}");
    let row_len: usize = out_buff.find('\n').unwrap() + 1;
    // println!("Number of spaces = {row_len}");

    let source_pos: (usize, usize) = linear2coords(find_source(&out_buff), row_len);
    // println!("source at = {source_pos:?}");

    let splitters: Vec<(usize, usize)> = find_splitters(&out_buff, row_len);
    // println!("splitters at {splitters:?}");

    put_beam(&mut out_buff, (source_pos.0 + 1, source_pos.1), row_len);
    // println!("{out_buff}");

    let mut beams: Vec<(usize, usize)> = find_beams(&mut out_buff, row_len);
    // println!("beams = {beams:?}");
    let mut acc: u64 = 0;
    split_beam_recursive(&mut out_buff, row_len, &splitters, &mut beams, &mut acc);
    println!("after");
    println!("{out_buff}");
    println!("beam split {acc} times")
}
