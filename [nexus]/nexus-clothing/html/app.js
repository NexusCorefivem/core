const app = document.getElementById("app");
const resourceName = "nexus-clothing";

function post(endpoint, payload) {
    return fetch(`https://${resourceName}/${endpoint}`, {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
        body: JSON.stringify(payload || {})
    }).then((response) => response.json());
}

function buildAppearance() {
    return {
        model: document.getElementById("model").value,
        components: {
            3: { drawable: Number(document.getElementById("comp3").value) || 0, texture: 0, palette: 0 },
            4: { drawable: Number(document.getElementById("comp4").value) || 0, texture: 0, palette: 0 },
            6: { drawable: Number(document.getElementById("comp6").value) || 0, texture: 0, palette: 0 },
            8: { drawable: Number(document.getElementById("comp8").value) || 0, texture: 0, palette: 0 },
            11: { drawable: Number(document.getElementById("comp11").value) || 0, texture: 0, palette: 0 }
        },
        props: {}
    };
}

function applyForm(appearance) {
    document.getElementById("model").value = appearance.model || "mp_m_freemode_01";
    document.getElementById("comp3").value = appearance.components?.[3]?.drawable ?? 15;
    document.getElementById("comp4").value = appearance.components?.[4]?.drawable ?? 21;
    document.getElementById("comp6").value = appearance.components?.[6]?.drawable ?? 34;
    document.getElementById("comp8").value = appearance.components?.[8]?.drawable ?? 15;
    document.getElementById("comp11").value = appearance.components?.[11]?.drawable ?? 15;
}

window.addEventListener("message", (event) => {
    const message = event.data;
    if (message.action === "open") {
        app.classList.remove("hidden");
        applyForm(message.payload.appearance || {});
    }

    if (message.action === "close") {
        app.classList.add("hidden");
    }
});

document.getElementById("previewButton").addEventListener("click", () => post("appearance:preview", buildAppearance()));
document.getElementById("saveButton").addEventListener("click", () => post("appearance:save", buildAppearance()));
document.getElementById("closeButton").addEventListener("click", () => post("appearance:close"));
