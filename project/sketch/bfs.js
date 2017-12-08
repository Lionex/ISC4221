function BFS(start, end) {
    this.start = start
    this.start.g = 0
    this.end = end
    this.current = start

    this.open = [start]

    this.converge = () => {
        return this.current.x == this.end.x && this.current.y == this.end.y
    }

    this.pop = () => {
        this.current = this.open.shift()
        this.current.close()

        return this.current
    }

    this.dist = (c,n) => {
        return Math.sqrt((c.x-n.x)*(c.x-n.x)+(c.y-n.y)*(c.y-n.y))
    }

    this.step = (neighbor) => {
        let g = this.dist(this.current,neighbor) + this.current.g
        if (g < neighbor.g) {
            neighbor.f = g
            neighbor.g = g
            neighbor.parent = this.current
        }
        if (neighbor.valid()) {
            if (neighbor.opened == false) {
                this.open.push(neighbor.open())
            }
        }
    }
}
