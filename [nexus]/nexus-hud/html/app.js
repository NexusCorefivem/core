window.addEventListener("message", (event) => {
    const message = event.data;
    if (message.action !== "hud:update") {
        return;
    }

    document.getElementById("health").textContent = message.payload.health;
    document.getElementById("armor").textContent = message.payload.armor;
});
