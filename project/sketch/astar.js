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
