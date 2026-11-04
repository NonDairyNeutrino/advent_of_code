use std::{
    env::{Args, args},
    fs::{File, copy},
    io::{BufRead, BufReader, Lines, Read, Seek},
    os::unix::fs::FileExt,
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

fn find_source(file_string: &String) -> (usize, usize) {
    let source_col = file_string
        .match_indices('S')
        .map(|pair| pair.0)
        .next()
        .unwrap();
    return (0_usize, source_col);
}

fn put_beam(file: &File, pos: u64) {
    if let Ok(bytes) = file.write_at("|".as_bytes(), pos) {
        println!("{bytes} written")
    } else {
        panic!("Nothing written!")
    }
}

fn print_file(file: &mut File, buff: &mut String) {
    buff.clear();
    let _ = file.seek(std::io::SeekFrom::Start(0));
    let _ = file.read_to_string(buff);
    println!("{buff}");
}

fn main() {
    let mut out_file: File = create_out(); // create output.txt that's a copy of the input
    let mut out_buf: String = String::new();

    print_file(&mut out_file, &mut out_buf);

    let source_pos: (usize, usize) = find_source(&out_buf);
    println!("source = {source_pos:?}");

    put_beam(&out_file, source_pos.0 as u64);
    print_file(&mut out_file, &mut out_buf);

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
