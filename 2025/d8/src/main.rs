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

fn compare_edge_distances(edge0: &(Point, Point), edge1: &(Point, Point)) -> std::cmp::Ordering {
    let (p00, p01): &(Point, Point) = edge0;
    let (p10, p11): &(Point, Point) = edge1;

    let p0_dist: f64 = p00.distance(&p01);
    let p1_dist: f64 = p10.distance(&p11);

    let comp = p0_dist.total_cmp(&p1_dist);
    return comp;
}

fn main() {
    let points: Vec<Point> = parse_input();

    let mut pairs: Vec<(Point, Point)> = Vec::with_capacity(points.len().pow(2));
    for p1 in points.as_slice() {
        for p2 in points.as_slice() {
            if p1.id != p2.id {
                pairs.push((*p1, *p2));
            }
        }
    }
    pairs.sort_by(|edge0, edge1| compare_edge_distances(edge0, edge1));
    pairs.dedup_by(|p0, p1| (p0.0.id, p0.1.id) == (p1.1.id, p1.0.id));
    for pair in pairs {
        println!("({}, {}) -> {}", pair.0, pair.1, pair.0.distance(&pair.1))
    }
}
