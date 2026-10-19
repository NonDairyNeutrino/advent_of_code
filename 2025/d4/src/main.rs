use std::env::args;
use std::fs::{/* File, */ read_to_string};
use std::path::Path;
// use std::str::Chars;

fn get_grid_size(grid: &Vec<char>) -> (usize, usize) {
    let nrows: usize = grid.iter().filter(|c| **c == '\n').count() + 1;
    // n_elements = n_rows * n_cols ==> n_cols = n_elements / nrows
    // need to ignore the newline characters
    let ncols: usize = (grid.len() - (nrows - 1)) / nrows;
    return (nrows, ncols);
}

fn is_roll(grid: &Vec<char>, i: usize, j: usize) -> bool {
    let ncols: usize = get_grid_size(grid).1 + 1; // + 1 to account for \n in indexing
    let row: usize = ncols * i;
    let col: usize = j;
    let idx: usize = row + col;
    // println!("i: {i}, j: {j}, idx: {idx}");
    return grid[idx] == '@';
}

// fn is_edge(grid: &Vec<char>, i: usize, j: usize) -> bool {
//     let (nrows, ncols): (usize, usize) = get_grid_size(grid);
//     let is_top: bool = i == 0;
//     let is_bot: bool = i == nrows;
//     let is_left: bool = j == 0;
//     let is_right: bool = j == ncols;
//     return is_top || is_bot || is_left || is_right;
// }

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
        if r < 0 || r >= (nrows as i64) {
            continue;
        }
        for c in left..right {
            if c < 0 || c >= (ncols as i64) {
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

fn is_accessible(grid: &Vec<char>, i: usize, j: usize, radius: usize, limit: u8) -> bool {
    // let isroll: bool = is_roll(grid, i, j);
    // if !isroll {
    //     println!("{:?} is not a roll", (i, j));
    //     return false;
    // }
    // ASSUME IT'S A ROLL
    let mut acc: u8 = 0;
    // let radius: usize = 1;
    let neighbors: Vec<(usize, usize)> = get_neighbors(grid, i, j, radius);

    for neighbor in neighbors {
        if is_roll(grid, neighbor.0, neighbor.1) {
            // println!("Neighbor {neighbor:?} is a roll");
            acc += 1;
            // short circuit as soon as possible
            if acc >= limit {
                return false;
            }
        }
    }
    return true;
}

fn parse_input(path: &Path) -> Vec<char> {
    let file_string: String = read_to_string(path).unwrap();
    let grid: Vec<char> = file_string.chars().collect();
    return grid;
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    let grid: Vec<char> = parse_input(path);
    // let site: (usize, usize) = (0, 2);
    let radius: usize = 1;
    let limit: u8 = 4;
    // println!("{grid:?}");
    // println!("Grid size: {:?}", get_grid_size(&grid));
    // println!("{site:?} is a roll: {}", is_roll(&grid, site.0, site.1));
    // println!(
    //     "{site:?} neighbors: {:?}",
    //     get_neighbors(&grid, site.0, site.1, radius)
    // );
    // println!(
    //     "{site:?} is accessible: {:?}",
    //     is_accessible(&grid, site.0, site.1, limit)
    // )
    let (nrows, ncols): (usize, usize) = get_grid_size(&grid);
    let mut n_acc: u8 = 0;
    let mut roll_sites: Vec<(usize, usize)> = Vec::new();

    for row in 0..nrows {
        for col in 0..ncols {
            if is_roll(&grid, row, col) {
                roll_sites.push((row, col));
            }
        }
    }
    println!("rolls: {roll_sites:?}");

    for roll_site in roll_sites {
        if is_accessible(&grid, roll_site.0, roll_site.1, radius, limit) {
            n_acc += 1;
        }
    }
    println!("{n_acc}")
}
