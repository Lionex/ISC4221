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
            window.innerWidth/3,
            window.innerWidth/3,
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
            window.innerWidth/3,
            window.innerWidth/3,
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
            window.innerWidth/3,
            window.innerWidth/3,
            (w, h) => new AStar(w,h)
        ),
        id: 'sketch-astar-c'
    }
]

window.onload = () => {
    sketches.map((o) => {
        console.log('Loading', o.id)
        new p5(o.sketch, o.id)
    })
}
