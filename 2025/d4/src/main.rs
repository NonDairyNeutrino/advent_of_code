use std::env::args;
use std::fs::{File, read_to_string};
use std::path::Path;
use std::str::Chars;

fn get_grid_size(grid: &Vec<char>) -> (usize, usize) {
    let nrows: usize = grid.iter().filter(|c| **c == '\n').count() + 1;
    // n_elements = n_rows * n_cols ==> n_cols = n_elements / nrows
    // need to ignore the newline characters
    let ncols: usize = (grid.len() - (nrows - 1)) / nrows;
    return (nrows, ncols);
}

fn is_roll(grid: &Vec<char>, i: usize, j: usize) -> bool {
    let ncols: usize = get_grid_size(grid).1;
    return grid[ncols * i + j] == '@';
}

fn is_edge(grid: &Vec<char>, i: usize, j: usize) -> bool {
    let (nrows, ncols): (usize, usize) = get_grid_size(grid);
    let is_top: bool = i == 0;
    let is_bot: bool = i == nrows;
    let is_left: bool = j == 0;
    let is_right: bool = j == ncols;
    return is_top || is_bot || is_left || is_right;
}

fn get_neighbors(grid: &Vec<char>, i: usize, j: usize, radius: usize) -> Vec<(usize, usize)> {
    let (nrows, ncols): (usize, usize) = get_grid_size(grid);
    // let n_neighbors: usize = (2 * radius + 1).pow(2) - 1; // get the manhattan area of the annulus
    let mut neighbors: Vec<(usize, usize)> = Vec::new();

    let top: i64 = (i as i64) - (radius as i64);
    let bot: i64 = (i as i64) + (radius as i64) + 1;
    let left: i64 = (j as i64) - (radius as i64);
    let right: i64 = (j as i64) + (radius as i64) + 1;

    for r in top..bot {
        // println!("r = {r}");
        if r < 0 || r > (nrows as i64) {
            continue;
        }
        for c in left..right {
            if c < 0 || c > (ncols as i64) {
                continue;
            }
            if (r, c) == (i as i64, j as i64) {
                continue;
            }
            neighbors.push((r as usize, c as usize));
        }
    }
    return neighbors;
}

fn is_accessible(grid: &Vec<char>, i: usize, j: usize) -> bool {
    let mut acc: u8 = 0;
    let (_nrows, ncols): (usize, usize) = get_grid_size(grid);
    let idx: usize = ncols * i + j;
    if !is_edge(grid, i, j) {
        // above-left
        if grid[idx - ncols /* up one row */ - 1 /* left one col */] == '@' {
            acc += 1
        }
        // above
        if grid[idx - ncols /* up one row */] == '@' {
            acc += 1
        }
        // above-right
        if grid[idx - ncols /* up one row */ + 1] == '@' {
            acc += 1
        }

        // left
        if grid[idx - 1] == '@' {
            acc += 1
        }

        // for consistency's sake
        // if grid[idx] == '@' {
        //     acc += 1
        // }

        // right
        if grid[idx + 1] == '@' {
            acc += 1
        }

        // below-left
        if grid[idx + ncols - 1] == '@' {
            acc += 1
        }
        // below
        if grid[idx + ncols] == '@' {
            acc += 1
        }
        // below-right
        if grid[idx + ncols + 1] == '@' {
            acc += 1
        }
    } else {
        todo!()
    }
    acc < 4
}

fn parse_input(path: &Path) {
    let file_string: String = read_to_string(path).unwrap();
    let grid: Vec<char> = file_string.chars().collect();
    // println!("{:?}", grid);
    println!("{:?}", get_neighbors(&grid, 0, 0, 1))
    // let rows: Vec<&str> = file_string.split('\n').collect();
    // let grid: Vec<Chars> = rows.iter().map(|row| row.chars()).collect();
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    parse_input(path);
}
