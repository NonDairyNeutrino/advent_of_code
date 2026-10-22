use std::env::args;
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::path::Path;

fn parse_input(path: &Path) -> (Vec<(u64, u64)>, Vec<u64>) {
    let file: File = File::open(path).unwrap(); // open the file
    let reader: BufReader<File> = BufReader::new(file);
    let linev: Vec<String> = reader.lines().map(|line| line.unwrap()).collect();

    let mut ranges: Vec<(u64, u64)> = Vec::new();
    let mut ids: Vec<u64> = Vec::new();

    for line in linev {
        if line.contains("-") {
            let range: Vec<&str> = line.split('-').collect();
            let (lower, upper): (u64, u64) = (range[0].parse().unwrap(), range[1].parse().unwrap());
            ranges.push((lower, upper));
        } else if !line.contains("-") {
            if let Ok(id) = line.parse::<u64>() {
                ids.push(id);
            }
        }
    }
    return (ranges, ids);
}

fn is_fresh_single(id: u64, range: (u64, u64)) -> bool {
    let (lb, ub) = range;
    let above: bool = lb <= id;
    let below: bool = id <= ub;
    let isfresh: bool = above && below;
    return isfresh;
}

fn is_fresh(id: u64, ranges: &Vec<(u64, u64)>) -> bool {
    let isfresh: bool = ranges.iter().any(|range| is_fresh_single(id, *range));
    if isfresh {
        println!("{id} is fresh")
    } else {
        println!("{id} is spoiled")
    }
    return isfresh;
}

fn is_overlapping(range_a: (u64, u64), range_b: (u64, u64)) -> bool {
    let (lba, uba) = range_a;
    let (lbb, ubb) = range_b;

    return is_fresh_single(lbb, range_a)
        || is_fresh_single(ubb, range_a)
        || is_fresh_single(uba, range_b)
        || is_fresh_single(lba, range_b);
}

fn interval_union_overlapping(range_a: (u64, u64), range_b: (u64, u64)) -> (u64, u64) {
    assert!(is_overlapping(range_a, range_b));
    let (lba, uba) = range_a;
    let (lbb, ubb) = range_b;
    let lb = lba.min(lbb);
    let ub = uba.max(ubb);
    return (lb, ub);
}

fn count_interval_members(interval: (u64, u64)) -> u64 {
    let nmembers: u64 = interval.1 - interval.0 + 1;
    println!("Interval {interval:?} has {}", nmembers);
    return nmembers;
}

fn reduce_recursive(domain: &mut Vec<(u64, u64)>) {
    let mut acc: usize = 0;
    let mut removed: Vec<usize> = Vec::new();
    println!("domain: {domain:?}");
    for d in 0..domain.len() {
        let doma: (u64, u64) = domain[d];
        // don't test intervals that have been marked for removal
        if removed.contains(&d) {
            println!("Skipping {:?}", doma);
            continue;
        }
        println!("testing {doma:?}");

        // if there exists a subdomain that overlaps with the range, search for it
        let interval_exists: bool = ((d + 1)..domain.len()).any(
            |j| is_overlapping(doma, domain[j]), /* && !removed.contains(&j) */
        );
        if interval_exists {
            println!("There exists an overlapping interval; searching...");
            for i in (d + 1/* overlap test is symmetric */)..domain.len() {
                let domb: (u64, u64) = domain[i];
                println!("testing if {domb:?} overlaps with {doma:?}");

                if removed.contains(&i) {
                    println!("{domb:?} is marked for removal; skipping");
                    continue;
                }

                if is_overlapping(doma, domb) {
                    println!("{:?} overlaps with {:?}", doma, domb);
                    domain[d] = interval_union_overlapping(doma, domb);
                    removed.push(i);
                    break;
                }
            }
            println!("domain is now: {domain:?}");
        } else {
            println!("{:?} does not overlap with any subdomain", doma);
            acc += 1;
            // domain.push(*dom);
        }
    }
    removed.sort();
    let rem_len: usize = removed.len();
    println!("Unions complete; removing {rem_len} intervals");
    for r in 0..rem_len {
        println!("Removing {:?}", domain[removed[(rem_len - 1) - r]]);
        domain.remove(removed[(rem_len - 1) - r]);
    }
    println!("overlaps removed; domain is now {domain:?}");
    // if no intervals were merged, then return
    if acc == domain.len() {
        return;
    }

    println!("RECURRING!");
    reduce_recursive(domain);
}

fn main() {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    let (ranges, _): (Vec<(u64, u64)>, Vec<u64>) = parse_input(path);
    println!("ranges: {ranges:?}");

    let mut domain: Vec<(u64, u64)> = Vec::new();
    domain.push(ranges[0]);
    for range in ranges {
        // if there exists a subdomain that overlaps with the range, search for it
        if domain.iter().any(|subdom| is_overlapping(*subdom, range)) {
            for i in 0..domain.len() {
                if is_overlapping(range, domain[i]) {
                    println!("{range:?} overlaps with {:?}", domain[i]);
                    domain[i] = interval_union_overlapping(domain[i], range);
                    break;
                }
            }
        } else {
            println!("{range:?} does not overlap with any subdomain");
            domain.push(range);
        }
        println!("domain is now: {domain:?}");
    }

    println!("RANGES FINISHED; COMMENCING RECURSIVE REDUCTION");
    reduce_recursive(&mut domain);

    let nmembers: u64 = domain
        .iter()
        .map(|interval| count_interval_members(*interval))
        .sum();
    println!("nmembers: {nmembers}");
}
