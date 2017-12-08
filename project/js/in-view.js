function check(element, shown, hidden) {
    if (collision_abab(page_rect(), element_rect(element))) {
        shown()
    } else {
        hidden()
    }
}

const visible_event = new Event('visible')
const invisible_event = new Event('invisible')

function view_event(element) {
    check(element,
        () => element.dispatchEvent(visible_event),
        () => element.dispatchEvent(invisible_event)
    )
}

function page_rect() {
    const x = window.pageXOffset
    const y = window.pageYOffset
    const w = 'innerWidth' in window? window.innerWidth : page.clientWidth
    const h = 'innerHeight' in window? window.innerHeight : page.clientHeight
    return [x, y, x+w, y+h]
}

function element_rect(element) {
    let x = 0
    let y = 0
    const w = element.offsetWidth
    const h = element.offsetHeight
    while (element.offsetParent!==null) {
        x += element.offsetLeft
        y += element.offsetTop
        element = element.offsetParent
    }
    return [x, y, x+w, y+h]
}

function collision_abab(a, b) {
    return a[0]<b[2] && a[2]>b[0] && a[1]<b[3] && a[3]>b[1]
}
