// OpenStreetMap maps (Leaflet) for the elements rendered by users/_map.html.haml.
// The element carries the coordinates, the popup text and the marker image URLs
// (fingerprinted by the asset pipeline) as data attributes.
import "leaflet" // UMD build: defines window.L

let maps = []

function drawMaps() {
  document.querySelectorAll("[data-user-map]").forEach((element) => {
    const data = element.dataset
    const position = [parseFloat(data.latitude), parseFloat(data.longitude)]
    const map = L.map(element, { scrollWheelZoom: false }).setView(position, 13)

    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 19,
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map)

    const icon = L.icon({
      iconUrl: data.markerIcon,
      iconRetinaUrl: data.markerIcon2x,
      shadowUrl: data.markerShadow,
      iconSize: [25, 41],
      iconAnchor: [12, 41],
      popupAnchor: [1, -34],
      shadowSize: [41, 41]
    })

    // The address is user input: set it as text, never as HTML.
    const label = document.createElement("span")
    label.textContent = data.label
    L.marker(position, { icon: icon, title: data.label }).addTo(map).bindPopup(label)

    maps.push(map)
  })
}

// Turbo caches a copy of the page before leaving it. Remove the maps first, so a
// restored page gets fresh maps instead of a copy of the old one.
function removeMaps() {
  maps.forEach((map) => map.remove())
  maps = []
}

document.addEventListener("turbo:load", drawMaps)
document.addEventListener("turbo:before-cache", removeMaps)
