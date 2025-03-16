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
    window.location.href = "/"; // Replace '/' with your homepage URL if different
}

const apiUrl = "/api/user/";

let currentPage = 1;
const rowsPerPage = 10;

async function fetchAndDisplayUser(page = 1, username = '', role = '', is_active = '') {
    try {
        // สร้าง query string เฉพาะพารามิเตอร์ที่มีค่า
        const queryParams = new URLSearchParams();
        queryParams.append("skip", (page - 1) * rowsPerPage);
        queryParams.append("limit", rowsPerPage);

        if (username) {
            queryParams.append("username", username);
        }

        if (role) {
            queryParams.append("role", role);
        }

        if (is_active) {
            queryParams.append("is_active", is_active);
        }

        // ส่งคำขอไปที่ API พร้อม query string
        const response = await fetch(`${apiUrl}?${queryParams.toString()}`, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}` // Attach the token in the Authorization header
            }
        });

        if (response.status === 401) {
            alert("Session expired. Redirecting to the homepage.");
            window.location.href = "/"; // Replace '/' with your homepage URL
            return;
        }

        if (!response.ok) {
            throw new Error("Failed to fetch units.");
        }

        const data = await response.json();
        const tableBody = document.getElementById("userTableBody");
        const pagination = document.getElementById("pagination");

        tableBody.innerHTML = ""; // Clear existing rows

        // Populate the table
        data.user.forEach((user, index) => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${index + 1}</td>
                <td>${user.username}</td>
                <td>${user.role}</td>
                <td>
                    <span class="status-dot ${user.is_active ? 'active' : 'inactive'}"></span>
                    ${user.is_active ? " พร้อมใช้งาน" : " ไม่พร้อมใช้งาน"}
                </td>
                <td>${formatDateToThai(user.created_at)}</td>
            `;
            tableBody.appendChild(row);
        });

        // Update pagination
        const totalPages = Math.ceil(data.total / rowsPerPage);
        updatePagination(totalPages, page);
    } catch (error) {
        console.error("Error fetching units:", error);
    }
}

document.addEventListener("DOMContentLoaded", fetchAndDisplayUser());

function formatDateToThai(dateString) {
    const date = new Date(dateString);
    const day = date.getDate(); // วันที่
    const month = date.toLocaleString("th-TH", { month: "long" }); // ชื่อเดือนแบบไทย
    const year = date.getFullYear() + 543; // แปลง ค.ศ. เป็น พ.ศ.
    return `${day} ${month} ${year}`;
}

function updatePagination(totalPages, currentPage) {
    const pagination = document.getElementById("pagination");
    pagination.innerHTML = ""; // Clear existing pagination

    for (let page = 1; page <= totalPages; page++) {
        const li = document.createElement("li");
        li.className = `page-item ${page === currentPage ? "active" : ""}`;
        li.innerHTML = `
            <a class="page-link" href="#">${page}</a>
        `;
        li.addEventListener("click", (event) => {
            event.preventDefault();
            fetchAndDisplayUser(page);
        });
        pagination.appendChild(li);
    }
}