window.addEventListener("message", (event) => {
    const payload = event.data.payload || {};
    if (event.data.action !== "hud:update") {
        return;
    }

    document.getElementById("health").textContent = payload.health ?? 0;
    document.getElementById("armor").textContent = payload.armor ?? 0;
    document.getElementById("cash").textContent = payload.cash ?? 0;
    document.getElementById("bank").textContent = payload.bank ?? 0;
    document.getElementById("job").textContent = payload.job || "-";
});
