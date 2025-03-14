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
const apiUrl = "/api/summary/";


async function fetchAndDisplaySummary(date_start, date_end) {
    try {

        const queryParams = new URLSearchParams();

        if (date_start) {
            queryParams.append("date_start", date_start);
        } else {
            queryParams.append("date_start", "2024-01-01");
        }

        if (date_end) {
            queryParams.append("date_end", date_end);
        } else {
            queryParams.append("date_end", "2100-01-01");
        }

        const response = await fetch(`${apiUrl}?${queryParams.toString()}`, {
            method: "GET",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}` // Attach the token in the Authorization header
            }
        });

        if (response.status === 401) {
            alert("Session expired. Redirecting to the homepage.");
            window.location.href = "/";
            return;
        }

        if (!response.ok) {
            throw new Error("Failed to fetch data.");
        }

        const data = await response.json();

        // 🔹 อัปเดตจำนวนภารกิจและกำลังพล
        document.getElementById("missionTotal").textContent = data.mission_all;
        document.getElementById("unitTotal").textContent = data.unit_all;

        // 🔹 อัปเดตกราฟ
        displayChart(data);

    } catch (error) {
        console.error("Error fetching data:", error);
    }
}

function displayChart(data) {
    document.getElementById("mission_pending_total").textContent = data.mission_pending;
    document.getElementById("mission_doing_total").textContent = data.mission_doing;
    document.getElementById("mission_done_total").textContent = data.mission_done;

    document.getElementById("unit_doing_mission_total").textContent = data.unit_doing_mission;
    document.getElementById("unit_not_doing_mission_total").textContent = data.unit_not_doing_mission;
    document.getElementById("unit_pending_total").textContent = data.unit_pending;



    // 🔹 กราฟภารกิจ
    new Chart(document.getElementById('missionChart').getContext('2d'), {
        type: 'doughnut',
        data: {
            labels: ['ดำเนินการ', 'เสร็จสิ้น', 'รอดำเนินการ'],
            datasets: [{
                data: [data.mission_doing, data.mission_done, data.mission_pending],
                backgroundColor: ['#007bff', '#28a745', '#ffc107']
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } }
        }
    });

    // 🔹 กราฟกำลังพล
    new Chart(document.getElementById('unitChart').getContext('2d'), {
        type: 'pie',
        data: {
            labels: ['ปฏิบัติภารกิจ', 'ว่าง', 'รอดำเนินการ'],
            datasets: [{
                data: [data.unit_doing_mission, data.unit_not_doing_mission, data.unit_pending],
                backgroundColor: ['#dc3545', '#17a2b8', '#6c757d']
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } }
        }
    });
}

// 🔹 โหลดข้อมูลจาก API เมื่อหน้าเว็บโหลดเสร็จ
document.addEventListener("DOMContentLoaded", fetchAndDisplaySummary());