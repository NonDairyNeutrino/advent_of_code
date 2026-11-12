use std::{
    env::args,
    fmt,
    fs::File,
    io::{BufRead, BufReader, Lines},
    path::Path,
};

#[derive(Debug, Clone, Copy)]
struct JuncBox {
    id: usize,
    x: f64,
    y: f64,
    z: f64,
}

impl JuncBox {
    fn distance(self, p: &JuncBox) -> f64 {
        let xdiff: f64 = self.x - p.x;
        let ydiff: f64 = self.y - p.y;
        let zdiff: f64 = self.z - p.z;
        let dist: f64 = (xdiff.powi(2) + ydiff.powi(2) + zdiff.powi(2)).sqrt();
        return dist;
    }
}
impl fmt::Display for JuncBox {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {}, {})", self.x, self.y, self.z)
    }
}

struct Connection {
    a: JuncBox,
    b: JuncBox,
    dist: f64,
}
impl fmt::Display for Connection {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {}) -> {}", self.a, self.b, self.dist)
    }
}

fn parse_input() -> Vec<JuncBox> {
    let args: Vec<String> = args().collect();
    let path: &Path = Path::new(&args[1]);
    let file: File = File::open(path).unwrap();
    let lineterator: Lines<BufReader<File>> = BufReader::new(file).lines();

    let mut boxes: Vec<JuncBox> = Vec::new();
    for (id, line) in lineterator.enumerate() {
        let jboxv: Vec<f64> = line
            .unwrap()
            .split(',')
            .map(|dim| dim.parse::<f64>().unwrap())
            .collect();
        let jbox: JuncBox = JuncBox {
            id: id,
            x: jboxv[0],
            y: jboxv[1],
            z: jboxv[2],
        };
        boxes.push(jbox);
    }
    return boxes;
}

fn compare_edge_distances(edge0: &Connection, edge1: &Connection) -> std::cmp::Ordering {
    let (p00, p01): (JuncBox, JuncBox) = (edge0.a, edge0.b);
    let (p10, p11): (JuncBox, JuncBox) = (edge1.a, edge1.b);

    let p0_dist: f64 = p00.distance(&p01);
    let p1_dist: f64 = p10.distance(&p11);

    let comp = p0_dist.total_cmp(&p1_dist);
    return comp;
}

fn make_conns(jboxs: &Vec<JuncBox>) -> Vec<Connection> {
    let mut conns: Vec<Connection> = Vec::with_capacity(jboxs.len().pow(2));
    for p1 in jboxs.as_slice() {
        for p2 in jboxs.as_slice() {
            if p1.id != p2.id {
                let con: Connection = Connection {
                    a: *p1,
                    b: *p2,
                    dist: p1.distance(p2),
                };
                conns.push(con);
            }
        }
    }
    return conns;
}

fn sort_conns(conns: &mut Vec<Connection>) -> &Vec<Connection> {
    conns.sort_by(|edge0, edge1| compare_edge_distances(edge0, edge1));
    conns.dedup_by(|p0, p1| (p0.a.id, p0.b.id) == (p1.b.id, p1.a.id));
    return conns;
}

fn find_component(graph: &Vec<Vec<bool>>, root_id: usize, comp: &mut Vec<usize>) {
    // proceed via depth-first search
    for (id, edge) in graph[root_id].iter().enumerate() {
        if *edge {
            comp.push(id);
            find_component(graph, id, comp)
        }
    }
}

fn main() {
    let jboxs: Vec<JuncBox> = parse_input();
    let mut conns: Vec<Connection> = make_conns(&jboxs);
    sort_conns(&mut conns);

    // start from one big graph
    // pick a point
    // find the minimum spanning tree using that point as the root
    // then pick a point not in that tree, and find the tree
    //
    // create the graph
    let mut graph: Vec<Vec<bool>> = Vec::with_capacity(jboxs.len());
    for _ in jboxs.as_slice() {
        let mut row: Vec<bool> = Vec::with_capacity(jboxs.len());
        for _ in jboxs.as_slice() {
            row.push(false);
        }
        graph.push(row);
    }

    // populate the graph
    let limit: usize = 10;
    for con in conns.iter().take(limit) {
        let row: usize = con.a.id;
        let col: usize = con.b.id;
        graph[row][col] = true;
    }

    for id in 0..graph.len() {
        let mut comp: Vec<usize> = Vec::new();
        find_component(&graph, id, &mut comp);
        println!("{comp:?}")
    }
}
