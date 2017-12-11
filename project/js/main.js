const width = window.innerWidth > 900 ?
    clamp(window.innerWidth*0.8/3.5+1, 200, 600) : 5*window.innerWidth/9
const height = Math.max(2*width/3, 350)

const sketches = [
    {
        sketch: sketch(
            u_start,
            u_end,
            u_obs,
            width,
            height,
            (w, h) => new BFS(w,h)
        ),
        id: 'sketch-bfs'
    },
    {
        sketch: sketch(
            u_start,
            u_end,
            (grid) => [],
            window.innerWidth > 900 ? Math.min(width * 2, 350) : width,
            window.innerWidth > 900 ? Math.min(width * 2, 350) : width,
            (w, h) => new BFS(w,h)
        ),
        id: 'sketch-bfs-c'
    },
    {
        sketch: sketch(
            u_start,
            u_end,
            u_obs,
            width,
            height,
            (w,h) => new Dijkstra(w,h)
        ),
        id: 'sketch-dijkstra'
    },
    {
        sketch: sketch(
            u_start,
            u_end,
            (grid) => [],
            window.innerWidth > 900 ? Math.min(width * 2, 350) : width,
            window.innerWidth > 900 ? Math.min(width * 2, 350) : width,
            (w, h) => new Dijkstra(w,h)
        ),
        id: 'sketch-dijkstra-c'
    },
    {
        sketch: sketch(
            u_start,
            u_end,
            u_obs,
            width,
            height,
            (w, h) => new AStar(w,h)
        ),
        id: 'sketch-astar'
    },
    {
        sketch: sketch(
            u_start,
            u_end,
            i_obs,
            window.innerWidth > 900 ? Math.min(width * 2, 350) : width,
            window.innerWidth > 900 ? Math.min(width * 2, 350) : width,
            (w, h) => new AStar(w,h)
        ),
        id: 'sketch-astar-c'
    }
]

window.onload = () => {
    sketches.map((o) => {
        let el = document.getElementById(o.id)
        let sketch = new p5(o.sketch, o.id)

        let loaded = false

        // Add listeners
        el.addEventListener('invisible', () => sketch.pause(), false)
        window.addEventListener('scroll', () => view_event(el))

        // Check if in view on page load
        view_event(el)
    })
}
