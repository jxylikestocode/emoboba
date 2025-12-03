// EmoBoba - Main JavaScript Functions
// Uses fetch().then().catch() pattern from course material

const API_BASE = "";

// Load dishes by mood for the recommend page
function loadDishesByMood(mood) {
  const container = document.getElementById("dishes-container");
  if (!container) return;

  container.innerHTML =
    '<p style="text-align: center; color: #666;">Loading dishes...</p>';

  fetch(API_BASE + "/api/dishes?mood=" + mood, { method: "GET" })
    .then((response) => response.json())
    .then((json) => {
      if (json.length === 0) {
        container.innerHTML =
          '<p style="text-align: center; color: #666;">No dishes found for this mood.</p>';
        return;
      }

      let html = "";
      json.forEach((dish) => {
        html += `
                    <a href="/dish/${dish.id}" class="dish-card">
                        <div class="dish-card-image">
                            ${
                              dish.image_url
                                ? `<img src="${dish.image_url}" alt="${dish.name}">`
                                : '<span class="dish-card-placeholder">🍜</span>'
                            }
                        </div>
                        <div class="dish-card-content">
                            <div class="dish-card-name">${dish.name}</div>
                            <div class="dish-card-hook">${dish.hook || ""}</div>
                            <div class="dish-card-restaurant">${
                              dish.restaurant_name
                            }</div>
                            <div class="dish-card-price">$${parseFloat(
                              dish.price
                            ).toFixed(2)}</div>
                        </div>
                    </a>
                `;
      });
      container.innerHTML = html;
    })
    .catch((error) => {
      console.error("Error loading dishes:", error);
      container.innerHTML =
        '<p style="text-align: center; color: #c62828;">Error loading dishes. Please try again.</p>';
    });
}

// Toggle favourite (add or remove)
function toggleFavourite(id, type) {
  return fetch(API_BASE + "/api/favourites/toggle", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      id: id,
      type: type,
    }),
  })
    .then((response) => response.json())
    .then((json) => {
      if (json.error) {
        if (json.error === "Login required") {
          window.location.href = "/login";
        } else {
          alert(json.error);
        }
        return null;
      }

      // Update button appearance
      const btn = document.getElementById("fav-btn");
      if (btn) {
        if (json.action === "added") {
          btn.style.background = "#d44a2a";
          btn.style.color = "white";
          if (type === "dish") {
            btn.innerHTML = `
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                        </svg>
                        Remove
                    `;
          } else {
            btn.innerHTML = `
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                        </svg>
                        Saved
                    `;
          }
        } else {
          btn.style.background = "rgba(255, 248, 240, 0.9)";
          btn.style.color = "#d44a2a";
          if (type === "dish") {
            btn.innerHTML = `
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                        </svg>
                        Add to favourites
                    `;
          } else {
            btn.innerHTML = `
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                        </svg>
                        Save
                    `;
          }
        }
      }

      return json;
    })
    .catch((error) => {
      console.error("Error toggling favourite:", error);
      alert("Error updating favourite. Please try again.");
      return null;
    });
}

// Get user's favourites
function getFavourites() {
  return fetch(API_BASE + "/api/favourites", { method: "GET" })
    .then((response) => response.json())
    .then((json) => {
      return json;
    })
    .catch((error) => {
      console.error("Error getting favourites:", error);
      return { dishes: [], restaurants: [] };
    });
}

// Get single dish details
function getDish(id) {
  return fetch(API_BASE + "/api/dishes/" + id, { method: "GET" })
    .then((response) => response.json())
    .then((json) => {
      return json;
    })
    .catch((error) => {
      console.error("Error getting dish:", error);
      return null;
    });
}

// Get single restaurant details
function getRestaurant(id) {
  return fetch(API_BASE + "/api/restaurants/" + id, { method: "GET" })
    .then((response) => response.json())
    .then((json) => {
      return json;
    })
    .catch((error) => {
      console.error("Error getting restaurant:", error);
      return null;
    });
}

// Get all moods
function getMoods() {
  return fetch(API_BASE + "/api/moods", { method: "GET" })
    .then((response) => response.json())
    .then((json) => {
      return json;
    })
    .catch((error) => {
      console.error("Error getting moods:", error);
      return [];
    });
}
