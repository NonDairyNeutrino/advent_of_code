use std::env::args;
use std::fs::{/* File, */ read_to_string};
use std::path::Path;
// use std::str::Chars;

fn parse_input(path: &Path) -> Vec<char> {
    let file_string: String = read_to_string(path).unwrap();
    let grid: Vec<char> = file_string.chars().collect();
    return grid;
}

fn get_grid_size(grid: &Vec<char>) -> (usize, usize) {
    let nrows: usize = grid.iter().filter(|c| **c == '\n').count() + 1;
    // n_elements = n_rows * n_cols ==> n_cols = n_elements / nrows
    // need to ignore the newline characters
    let ncols: usize = (grid.len() - (nrows - 1)) / nrows;
    return (nrows, ncols);
}

fn site_to_index(ncols: usize, site: (usize, usize)) -> usize {
    let row: usize = ncols * site.0;
    let col: usize = site.1;
    let idx: usize = row + col;
    return idx;
}

fn is_roll(grid: &Vec<char>, site: (usize, usize)) -> bool {
    let ncols: usize = get_grid_size(grid).1 + 1; // + 1 to account for \n in indexing
    let idx: usize = site_to_index(ncols, site);
    return grid[idx] == '@';
}

fn find_rolls(grid: &Vec<char>) -> Vec<(usize, usize)> {
    let (nrows, ncols): (usize, usize) = get_grid_size(&grid);
    let mut roll_sites: Vec<(usize, usize)> = Vec::new();

    for row in 0..nrows {
        for col in 0..ncols {
            if is_roll(&grid, (row, col)) {
                roll_sites.push((row, col));
            }
        }
    }

    return roll_sites;
}

fn get_neighbors(
    dims: (usize, usize),
    site: &(usize, usize),
    radius: usize,
) -> Vec<(usize, usize)> {
    let (nrows, ncols): (usize, usize) = dims;
    // let n_neighbors: usize = (2 * radius + 1).pow(2) - 1; // get the manhattan area of the annulus
    let mut neighbors: Vec<(usize, usize)> = Vec::new();

    let (i, j): (usize, usize) = *site;
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

fn is_accessible(
    dims: (usize, usize),
    sites: &Vec<(usize, usize)>,
    site: &(usize, usize),
    radius: usize,
    limit: u8,
) -> bool {
    let mut acc: u8 = 0;
    let neighbors: Vec<(usize, usize)> = get_neighbors(dims, site, radius);

    for neighbor in neighbors {
        if sites.contains(&neighbor) {
            acc += 1;
        }
    }
    return acc < limit;
}

fn find_accessible(
    roll_sites: &Vec<(usize, usize)>,
    dims: (usize, usize),
    radius: usize,
    limit: u8,
) -> Vec<usize> {
    let mut accessible: Vec<usize> = Vec::new();
    for idx in 0..roll_sites.len() {
        let site: (usize, usize) = roll_sites[idx];
        if is_accessible(dims, &roll_sites, &site, radius, limit) {
            accessible.push(idx);
        }
    }
    return accessible;
}

fn find_and_remove(
    roll_sites: &mut Vec<(usize, usize)>,
    dims: (usize, usize),
    radius: usize,
    limit: u8,
) -> usize {
    let accessible = find_accessible(&roll_sites, dims, radius, limit);
    if accessible.is_empty() {
        return 0;
    }
    println!("Found {} accessible rolls", accessible.len());
    // remove accessible rolls from roll sites
    for i in 0..accessible.len() {
        let idx: usize = accessible[i];
        roll_sites.remove(idx - i);
    }
    return accessible.len() + find_and_remove(roll_sites, dims, radius, limit);
}

fn main() {
    let radius: usize = 1;
    let limit: u8 = 4;

    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    let grid: Vec<char> = parse_input(path);

    let dims: (usize, usize) = get_grid_size(&grid);
    // get list of roll sites
    let mut roll_sites: Vec<(usize, usize)> = find_rolls(&grid);
    // determine which rolls are accessible
    let acc_tot: usize = find_and_remove(&mut roll_sites, dims, radius, limit);
    println!("{acc_tot}");

    // println!("Number of accessible rolls: {}", roll_sites.len())
}
