const bfs = function( p ) {

// Preamble

const clamp = (v, min, max) => {
    return Math.min(Math.max(v, min), max)
}

const width = clamp(window.innerWidth*0.8/3.33, 200, 700)
const height = Math.max(2*width/3, 300)
const cell_size = Math.max(width/20,height/20)-1

const dist = (c, n) => {
    return Math.sqrt(Math.pow(c.x-n.x,2)+Math.pow(c.y-n.y,2))
}

function Node(x,y) {
    this.x = x
    this.y = y

    this.f = Infinity

    this.parent = undefined

    this.closed = false
    this.opened = false
    this.obstacle = false

    this.draw = (x,y,size) => {
        if (!this.obstacle){
            if (this.obstacle) {
                p.fill(0x000)
            } else if (this.closed) {
                p.fill(p.color(205, 92, 92))
            } else if (this.opened) {
                p.fill(p.color(0,255,0))
            } else {
                p.fill(0xffffff)
            }
            p.rect(x-size/2, y-size/2, size*0.95, size*0.95)
        }
    }

    this.open = () => {
        this.opened = true
        return this
    }

    this.close = () => {
        this.opened = false
        this.closed = true
    }

    this.valid = () => {
        return !(this.closed || this.obstacle)
    }
}

function Grid(size, w, h) {
    this.cell = size
    this.width = w
    this.height = h
    this.nodes = new Array(this.width)
    for (let x = 0; x < this.width; x++) {
        this.nodes[x] = new Array(this.height)
    }

    for (let x = 0; x < this.width; x++) {
        for (let y = 0; y < this.height; y++) {
            this.nodes[x][y] = new Node(x,y)
        }
    }

    this.draw = (canvas_w, canvas_h) => {
        this.x_offset = (canvas_w - ((this.width-1) * this.cell)) / 2
        this.y_offset = (canvas_h - ((this.height-1) * this.cell)) / 2
        for (let x = 0; x < this.width; x++) {
            for (let y = 0; y < this.height; y++) {
                let px = x*this.cell+this.x_offset
                let py = y*this.cell+this.y_offset
                this.nodes[x][y].draw(px,py,this.cell)
            }
        }
    }

    this.size = () => { return [this.width, this.height] }

    this.obstacles = (obs) => {
        obs.map((o) => {this.nodes[o.x][o.y].obstacle = true})
    }
}


let grid = new Grid(
    cell_size,
    Math.floor(width/cell_size),
    Math.floor(height/cell_size)
)

let start = grid.nodes[0][Math.floor(grid.height/2)].open()
start.f = 0
let end = grid.nodes[grid.width-1][Math.floor(grid.height/2)]
let current = start

let open = [start]

// Define sketch

p.setup = () => {
    let canvas = p.createCanvas(width,height)
    let obstacles = []

    // Create U shaped obstacles to test performance
    x_max = grid.width-Math.floor(3*grid.width/8)
    x_min = Math.floor(3*grid.width/8)
    y_max = grid.height-Math.floor(grid.height/4)
    y_min = Math.floor(grid.height/4)
    for (let y = y_min; y <= y_max; y++) {
        obstacles.push({x: x_max, y: y})
    }
    for (let x = x_min; x < x_max; x++) {
        obstacles.push({x: x, y: y_min})
        obstacles.push({x: x, y: y_max})
    }
    if (Math.ceil(x_min/3) >= 3) {
        let d = Math.floor((y_max-y_min)/3)
        for (let y = y_min+d; y <= y_max-d; y++) {
            obstacles.push({x: Math.ceil(x_min/3), y: y})
        }
    }

    grid.obstacles(obstacles)
    console.log('Start BFS')
}

p.draw = () => {
    if (open.length > 0) {
        // Open the next most optimal node and add it to the closed set
        current = open.shift()
        current.close()

        if (current.x == end.x && current.y == end.y) {
            console.log('finished BFS')
            p.noLoop()
        }

        // Get list of neighbor positions, and bounds check on each
        let x = current.x
        let y = current.y
        let n = [
            {x: x+1, y: y},
            {x: x,   y: y+1},
            {x: x+1, y: y+1},
            {x: x-1, y: y},
            {x: x-1, y: y-1},
            {x: x,   y: y-1},
            {x: x+1, y: y-1},
            {x: x-1, y: y+1}
        ]
        for (let i = 0; i < n.length; i++) {
            if (n[i].x >= 0 && n[i].x < grid.width && n[i].y >= 0 && n[i].y < grid.height) {
                let neighbor = grid.nodes[n[i].x][n[i].y]
                // If we have a valid neighbor, explore following BFS's algorithm
                let f = dist(current,neighbor) + current.f
                if (f < neighbor.f) {
                    neighbor.f = f
                    neighbor.parent = current
                }
                if (neighbor.valid()) {
                    if (neighbor.opened == false) {
                        open.push(neighbor.open())
                    }
                }
            }
        }
    } else {
        p.noLoop()
    }

    // Render graph search
    p.background(0)
    grid.draw(width,height)

    while (current.parent) {
        let parent = current.parent
        let cx = current.x*grid.cell+grid.x_offset
        let cy = current.y*grid.cell+grid.y_offset
        let px = parent.x*grid.cell+grid.x_offset
        let py = parent.y*grid.cell+grid.y_offset
        p.stroke(173, 216, 230)
        p.strokeWeight(grid.cell/4)
        p.line(cx,cy,px,py)
        p.noStroke()
        current = parent
    }
}

}

const p5_bfs = new p5(bfs, 'sketch-bfs')
