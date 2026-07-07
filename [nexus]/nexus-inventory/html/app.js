const app = document.getElementById("app");
const grid = document.getElementById("grid");
const closeButton = document.getElementById("closeButton");
const resourceName = "nexus-inventory";

function post(endpoint, payload) {
    return fetch(`https://${resourceName}/${endpoint}`, {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
        body: JSON.stringify(payload || {})
    }).then((response) => response.json());
}

async function refresh() {
    const response = await post("inventory:refresh");
    renderItems(response.items || []);
}

function renderItems(items) {
    grid.innerHTML = "";
    items.forEach((item) => {
        const div = document.createElement("div");
        div.className = "slot";
        div.innerHTML = `
            <strong>${item.label || item.name}</strong>
            <div>Slot: ${item.slot}</div>
            <div>Count: ${item.count}</div>
            <div class="actions">
                <button data-use="${item.slot}">Use</button>
                <button data-drop="${item.slot}">Drop</button>
                <button data-give="${item.slot}">Give</button>
            </div>
        `;
        grid.appendChild(div);
    });
}

window.addEventListener("message", (event) => {
    const message = event.data;
    if (message.action === "open") {
        app.classList.remove("hidden");
        renderItems(message.payload.items || []);
    }

    if (message.action === "close") {
        app.classList.add("hidden");
    }
});

grid.addEventListener("click", async (event) => {
    const useSlot = event.target.getAttribute("data-use");
    const dropSlot = event.target.getAttribute("data-drop");
    const giveSlot = event.target.getAttribute("data-give");

    if (useSlot) {
        await post("inventory:use", { slot: Number(useSlot) });
        await refresh();
    }

    if (dropSlot) {
        await post("inventory:drop", { slot: Number(dropSlot), count: 1 });
        await refresh();
    }

    if (giveSlot) {
        const target = window.prompt("Target player id");
        if (target) {
            await post("inventory:give", { slot: Number(giveSlot), count: 1, target: Number(target) });
            await refresh();
        }
    }
});

closeButton.addEventListener("click", () => post("inventory:close"));
