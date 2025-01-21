function getCookie(name) {
    let cookieArr = document.cookie.split(";");
    for (let i = 0; i < cookieArr.length; i++) {
        let cookie = cookieArr[i].trim();
        if (cookie.startsWith(name + "=")) {
            return cookie.substring(name.length + 1);
        }
    }
    return null;
}

// Use this function to retrieve the token
let token = getCookie("access_token");

// Redirect to home if no token
if (!token) {
    // window.location.href = "/"; // Replace '/' with your homepage URL if different
}

// API endpoint URL
const apiUrl = "/api/unit/";

// Function to fetch data and populate the table
async function fetchAndDisplayUnits() {
    try {
        const response = await fetch(apiUrl, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}` // Attach the token in the Authorization header
            }
        });

        if (response.status === 401) {
            // If the token is invalid or expired, redirect to the homepage
            alert("Session expired. Redirecting to the homepage.");
            // window.location.href = "/"; // Replace '/' with your homepage URL
            return;
        }

        if (!response.ok) {
            throw new Error("Failed to fetch units.");
        }

        const data = await response.json();

        const tableBody = document.getElementById("unitTableBody");
        tableBody.innerHTML = ""; // Clear existing rows

        data.forEach((unit, index) => {
            const row = document.createElement("tr");

            row.innerHTML = `
                <td>${index + 1}</td>
                <td>${unit.position_id || "N/A"}</td>
                <td>${unit.first_name} ${unit.last_name}</td>
                <td>${unit.dept_id || "N/A"}</td>
                <td>${unit.status || "Active"}</td>
            `;

            tableBody.appendChild(row);
        });
    } catch (error) {
        console.error("Error fetching units:", error);
    }
}

// Fetch and display units on page load
document.addEventListener("DOMContentLoaded", fetchAndDisplayUnits);
