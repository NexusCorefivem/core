const app = document.getElementById("app");
const title = document.getElementById("title");
const itemsContainer = document.getElementById("items");
const resourceName = "nexus-menu";

function post(endpoint, payload) {
    return fetch(`https://${resourceName}/${endpoint}`, {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
        body: JSON.stringify(payload || {})
    }).then((response) => response.json());
}

window.addEventListener("message", (event) => {
    const message = event.data;
    if (message.action === "menu:open") {
        app.classList.remove("hidden");
        title.textContent = message.payload.title || "Nexus Menu";
        itemsContainer.innerHTML = "";
        (message.payload.items || []).forEach((item, index) => {
            const div = document.createElement("div");
            div.className = "item";
            div.textContent = item.label || "Item";
            div.addEventListener("click", () => post("menu:select", { index: index + 1 }));
            itemsContainer.appendChild(div);
        });
    }

    if (message.action === "menu:close") {
        app.classList.add("hidden");
    }
});

document.getElementById("closeButton").addEventListener("click", () => post("menu:close"));
