const app = document.getElementById("app");
const characterList = document.getElementById("characterList");
const createForm = document.getElementById("createForm");
const localeSelect = document.getElementById("locale");
const statusText = document.getElementById("statusText");
const closeButton = document.getElementById("closeButton");

const resourceName = "nexus-characters";

function post(endpoint, payload) {
    return fetch(`https://${resourceName}/${endpoint}`, {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
        body: JSON.stringify(payload || {})
    }).then((response) => response.json());
}

function setStatus(message) {
    statusText.textContent = message || "";
}

function renderLocales(locales) {
    localeSelect.innerHTML = "";
    (locales || []).forEach((locale) => {
        const option = document.createElement("option");
        option.value = locale;
        option.textContent = locale.toUpperCase();
        localeSelect.appendChild(option);
    });
}

function renderCharacters(characters) {
    characterList.innerHTML = "";

    (characters || []).forEach((character) => {
        const card = document.createElement("div");
        card.className = "card";
        card.innerHTML = `
            <strong>${character.firstname} ${character.lastname}</strong>
            <div>${character.citizenid}</div>
            <div>${character.dateofbirth || "1990-01-01"} | ${(character.locale || "nl").toUpperCase()}</div>
            <div class="row">
                <button data-select="${character.id}">Play</button>
                <button class="danger" data-delete="${character.id}">Delete</button>
            </div>
        `;
        characterList.appendChild(card);
    });
}

window.addEventListener("message", (event) => {
    const message = event.data;
    if (message.action === "open") {
        app.classList.remove("hidden");
        renderCharacters(message.payload.characters || []);
        renderLocales(message.payload.locales || ["nl", "en", "de", "fr"]);
        setStatus("");
    }

    if (message.action === "close") {
        app.classList.add("hidden");
    }
});

characterList.addEventListener("click", async (event) => {
    const selectId = event.target.getAttribute("data-select");
    const deleteId = event.target.getAttribute("data-delete");

    if (selectId) {
        await post("character:select", { id: Number(selectId) });
    }

    if (deleteId) {
        const result = await post("character:delete", { id: Number(deleteId) });
        if (!result.ok) {
            setStatus("Failed to delete character.");
        }
    }
});

createForm.addEventListener("submit", async (event) => {
    event.preventDefault();
    const payload = {
        firstname: document.getElementById("firstname").value,
        lastname: document.getElementById("lastname").value,
        dateofbirth: document.getElementById("dateofbirth").value,
        gender: document.getElementById("gender").value,
        locale: localeSelect.value
    };

    const result = await post("character:create", payload);
    if (!result.ok) {
        setStatus("Failed to create character.");
        return;
    }

    createForm.reset();
    setStatus("Character created.");
});

closeButton.addEventListener("click", () => post("character:close"));
