const app = document.getElementById("app");
const inbox = document.getElementById("inbox");

function post(endpoint, payload) {
    return fetch(`https://nexus-phone/${endpoint}`, {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
        body: JSON.stringify(payload || {})
    }).then((r) => r.json());
}

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
    if (message.action === "open") setVisible(true);
    if (message.action === "close") setVisible(false);
    if (message.action === "message") {
        inbox.textContent = `${message.payload.from}: ${message.payload.message}`;
    }
});

document.getElementById("send").addEventListener("click", () => {
    post("phone:send", {
        target: document.getElementById("target").value,
        message: document.getElementById("message").value
    });
});

document.getElementById("close").addEventListener("click", () => post("phone:close"));
