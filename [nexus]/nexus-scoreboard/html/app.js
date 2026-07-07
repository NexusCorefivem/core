const app = document.getElementById("app");
const list = document.getElementById("list");

function setVisible(visible) {
    if (visible) {
        app.classList.remove("hidden");
        app.style.display = "flex";
    } else {
        app.classList.add("hidden");
        app.style.display = "none";
    }
}

window.addEventListener("message", (event) => {
    const message = event.data;
    if (message.action === "open") {
        setVisible(true);
        list.innerHTML = "";
        (message.payload.players || []).forEach((player) => {
            const row = document.createElement("div");
            row.className = "row";
            row.textContent = `[${player.id}] ${player.name} - ${player.job} (${player.grade})`;
            list.appendChild(row);
        });
    }
    if (message.action === "close") setVisible(false);
});

document.getElementById("close").addEventListener("click", () => {
    fetch("https://nexus-scoreboard/scoreboard:close", { method: "POST", body: "{}" });
});
