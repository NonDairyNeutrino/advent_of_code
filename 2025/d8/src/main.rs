use std::{
    env::args,
    fmt,
    fs::File,
    io::{BufRead, BufReader, Lines},
    path::Path,
};

#[derive(Debug, Clone, Copy)]
struct Point {
    id: usize,
    x: f64,
    y: f64,
    z: f64,
}

impl Point {
    fn distance(self, p: &Point) -> f64 {
        let xdiff: f64 = self.x - p.x;
        let ydiff: f64 = self.y - p.y;
        let zdiff: f64 = self.z - p.z;
        let dist: f64 = (xdiff.powi(2) + ydiff.powi(2) + zdiff.powi(2)).sqrt();
        return dist;
    }

    fn is_connected(self, p: &Point, dmat: &Vec<Vec<f64>>) -> bool {
        if self.id == p.id {
            return false;
        }
        // A point B is connected to a point A, where A != B, if the distance between
        // B and A is less than the distance between any other point and A.
        // In other words, if there exists a distance between any two points that is greater
        // than the distance between A and B, A and B are not connected.
        let maybe: f64 = dmat[self.id][p.id];
        // now maybe is guarenteed to not be zero
        for row in dmat {
            for dist in row {
                if *dist > maybe {
                    return false;
                }
            }
        }
        return true;
    }
}
impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {}, {})", self.x, self.y, self.z)
    }
}

struct _Circuit {
    boxes: Vec<Point>,
}

fn parse_input() -> Vec<Point> {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    let file: File = File::open(path).unwrap();
    let lineterator: Lines<BufReader<File>> = BufReader::new(file).lines();

    let mut boxes: Vec<Point> = Vec::new();
    for (id, line) in lineterator.enumerate() {
        let pointv: Vec<f64> = line
            .unwrap()
            .split(',')
            .map(|dim| dim.parse::<f64>().unwrap())
            .collect();
        let point: Point = Point {
            id: id,
            x: pointv[0],
            y: pointv[1],
            z: pointv[2],
        };
        boxes.push(point);
    }
    return boxes;
}

fn get_distance_matrix(points: &[Point]) -> Vec<Vec<f64>> {
    points
        .iter()
        .map(|p1| points.iter().map(|p2| p1.distance(&p2)).collect())
        .collect()
}

fn main() {
    let points: Vec<Point> = parse_input();
    let dmat: Vec<Vec<f64>> = get_distance_matrix(&points);

    // for p1 in points.as_slice() {
    //     for p2 in points.as_slice() {
    //         if p1.is_connected(&p2, &dmat) {
    //             println!(
    //                 "{p1} is connected to {p2} with distance {}",
    //                 dmat[p1.id][p2.id]
    //             )
    //         }
    //     }
    // }
    // println!(
    //     "The real lowest distance is between {} and {} and is {}",
    //     points[0],
    //     points.last().unwrap(),
    //     dmat[points[0].id][points.last().unwrap().id]
    // )
}
