function AStar(start, end) {
    this.start = start
    this.start.g = 0
    this.end = end
    this.current = start

    this.open = new PriorityQueue({
        comparator: (a,b) => {
            if (a.f < b.f) {
                return -1
            } else if (a.f > b.f) {
                return 1
            } else {
                return 0
            }
        },
        initialValues: [start]
    })

    this.converge = () => {
        return this.current.x == this.end.x && this.current.y == this.end.y
    }

    this.pop = () => {
        this.current = this.open.dequeue()
        this.current.close()

        return this.current
    }

    this.dist = (c,n) => {
        return Math.sqrt((c.x-n.x)*(c.x-n.x)+(c.y-n.y)*(c.y-n.y))
    }

    this.step = (neighbor) => {
        if (neighbor.valid()) {
            let cost = this.dist(this.current,neighbor)
            let g = cost + this.current.g
            if (g < neighbor.g) {
                let h = this.dist(this.end,neighbor)
                neighbor.g = g
                neighbor.parent = this.current
                neighbor.h = h
                neighbor.f = 0.6*neighbor.g + h
                if (neighbor.opened == false) {
                    this.open.queue(neighbor.open())
                }
            }
        }
    }
}

const sketch = (Search) => {return function( p ) {

// Preamble

const u_obs = (grid) => {
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

    return obstacles
}

const clamp = (v, min, max) => {
    return Math.min(Math.max(v, min), max)
}

const width = clamp(window.innerWidth*0.8/3.33, 200, 700)
const height = Math.max(2*width/3, 300)
const cell_size = Math.max(width/20,height/20)-1

function Node(x,y) {
    this.x = x
    this.y = y

    this.f = 0
    this.g = Infinity
    this.h = 0

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

    this.start = this.nodes[0][0]

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

    this.map_neighborhood = (c, f) => {
        let x = c.x
        let y = c.y
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
            if (n[i].x >= 0 && n[i].x < this.width && n[i].y >= 0 && n[i].y < this.height) {
                let neighbor = grid.nodes[n[i].x][n[i].y]
                f(neighbor)
            }
        }
    }
}

let grid = new Grid(
    cell_size,
    Math.floor(width/cell_size),
    Math.floor(height/cell_size)
)

let Search = undefined

// Define sketch

p.setup = () => {
    let canvas = p.createCanvas(width,height)

    let obstacles = u_obs(grid)

    grid.obstacles(obstacles)

    let start = grid.nodes[0][Math.floor(grid.height/2)].open()
    start.g = 0
    let end = grid.nodes[grid.width-1][Math.floor(grid.height/2)]

    search = new AStar(
        start,
        end,
    )
    console.log('Start A*')
}

p.draw = () => {
    let current = search.current
    if (search.open.length > 0) {
        // Open the next most optimal node and add it to the closed set
        current = search.pop()

        if (search.converge()) {
            console.log('Finished A*')
            p.noLoop()
        }

        // Perform search operation on every neighbor
        grid.map_neighborhood(current, (neighbor) => {
            // If we have a valid neighbor, perform search step which evaulates
            // each neighbor according to the rules of the particular search
            // algorithm
            search.step(neighbor)
        })
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
}}

}

const p5_astar = new p5(sketch(AStar), 'sketch-astar')
