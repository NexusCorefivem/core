const container = document.getElementById("notifications");

window.addEventListener("message", (event) => {
    const message = event.data;
    if (message.action !== "notify") {
        return;
    }

    const toast = document.createElement("div");
    toast.className = "toast";
    toast.textContent = message.message;
    container.appendChild(toast);

    setTimeout(() => {
        toast.remove();
    }, 3500);
});
