const app = document.getElementById("app");
const vehicleList = document.getElementById("vehicleList");
const closeButton = document.getElementById("closeButton");
const refreshButton = document.getElementById("refreshButton");
const resourceName = "nexus-garages";

function post(endpoint, payload) {
    return fetch(`https://${resourceName}/${endpoint}`, {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
        body: JSON.stringify(payload || {})
    }).then((response) => response.json());
}

function renderVehicles(vehicles) {
    vehicleList.innerHTML = "";
    (vehicles || []).forEach((vehicle) => {
        const card = document.createElement("div");
        card.className = "card";
        card.innerHTML = `
            <strong>${vehicle.model}</strong>
            <div>Plate: ${vehicle.plate}</div>
            <div>Garage: ${vehicle.garage}</div>
            <div>State: ${vehicle.state}</div>
            <div>Fuel: ${Math.floor(vehicle.fuel || 100)}</div>
            <div class="actions">
                <button data-spawn="${vehicle.plate}">Spawn</button>
            </div>
        `;
        vehicleList.appendChild(card);
    });
}

window.addEventListener("message", (event) => {
    const message = event.data;
    if (message.action === "open") {
        app.classList.remove("hidden");
        renderVehicles(message.payload.vehicles || []);
    }

    if (message.action === "close") {
        app.classList.add("hidden");
    }
});

vehicleList.addEventListener("click", async (event) => {
    const plate = event.target.getAttribute("data-spawn");
    if (plate) {
        await post("garage:spawn", { plate });
    }
});

refreshButton.addEventListener("click", async () => {
    const response = await post("garage:refresh");
    renderVehicles(response.vehicles || []);
});

closeButton.addEventListener("click", () => post("garage:close"));
