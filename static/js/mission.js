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

// API endpoint URL
const apiUrl = "/api/mission/";

// Variables for pagination
let currentPage = 1;
const rowsPerPage = 10;

// Function to fetch and display units
async function fetchAndDisplayMission(page = 1, position = '', dept = '', status = '',name = '') {
    try {
        // สร้าง query string เฉพาะพารามิเตอร์ที่มีค่า
        const queryParams = new URLSearchParams();
        // queryParams.append("skip", (page - 1) * rowsPerPage);
        // queryParams.append("limit", rowsPerPage);

        // console.log(name);

        // if (position) {
        //     queryParams.append("position_id", position);
        // }
        // if (dept) {
        //     queryParams.append("dept_id", dept);
        // }
        // if (status) {
        //     queryParams.append("status", status);
        // }
        // if (name) {
        //     queryParams.append("name", name);
        // }

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
        const tableBody = document.getElementById("missionTableBody");
        const pagination = document.getElementById("pagination");

        tableBody.innerHTML = ""; // Clear existing rows

        // Populate the table
        data.missions.forEach((mission, index) => {
            const statusColor = mission.mission_status === "r" ? "green" : "red";
            const row = document.createElement("tr");
            const missionStartDate = formatDateToThai(mission.mission_start);
            const missionEndDate = formatDateToThai(mission.mission_end);

            console.log(mission);

            row.innerHTML = `
                <td>${(page - 1) * rowsPerPage + index + 1}</td>
                <td>${mission.mission_name || "N/A"}</td>
                <td>${missionStartDate}</td>
                <td>${missionEndDate || "N/A"}</td>
                <td>
                    <span class="status-circle" style="background-color: ${statusColor};"></span>
                </td>
                <td>
                    <button class="btn btn-info btn-sm" data-id="${mission.mission_id}" onclick="showMissionDetail(${mission.mission_id})">รายละเอียด</button>
                </td>
            `;
            tableBody.appendChild(row);
        });

        // Update pagination
        const totalPages = Math.ceil(data.total / rowsPerPage);
        // updatePagination(totalPages, page);
    } catch (error) {
        console.error("Error fetching units:", error);
    }
}

function formatDateToThai(dateString) {
    const date = new Date(dateString);
    const day = date.getDate(); // วันที่
    const month = date.toLocaleString("th-TH", { month: "long" }); // ชื่อเดือนแบบไทย
    const year = date.getFullYear() + 543; // แปลง ค.ศ. เป็น พ.ศ.
    return `${day} ${month} ${year}`;
}

document.addEventListener("DOMContentLoaded", function () {
    async function showMissionDetail(missionId) {
        try {
            const response = await fetch(`${apiUrl}${missionId}`, {
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
                throw new Error("Failed to fetch unit details.");
            }

            const data = await response.json();
            console.log(data.mission_name);
            // แสดงข้อมูลใน modal
            document.getElementById('missionDetailName').innerHTML = "<strong class='pe-3'>ภารกิจ:</strong> " + "<br>" + " " + data.mission_name;
            // document.getElementById("modalPositionName").textContent = data.position_name;
            // document.getElementById("unitDetailName").innerHTML = "<strong class='pe-3'>ชื่อ:</strong> " + "<br>" + data.position_name + " " + data.first_name + " " + data.last_name;
            // document.getElementById("deptDetailName").innerHTML = "<strong class='pe-3'>สังกัด:</strong> " + "<br>" + data.dept_name;
            // document.getElementById("identifyIdDetail").innerHTML = "<strong class='pe-3'>หมายเลขประจำตัว:</strong> " + "<br>" + data.identify_id;
            // document.getElementById("identifySoldierIdDetail").innerHTML = "<strong class='pe-3'>หมายเลขประจำตัวทหาร:</strong> " + "<br>" + data.identify_soldier_id;
            // document.getElementById("telDetail").innerHTML = "<strong class='pe-3'>เบอร์โทร:</strong> " + "<br>" + data.tel;
            // document.getElementById("bloodGroupDetail").innerHTML = "<strong class='pe-3'>กรุ๊ปเลือด:</strong> " + "<br>" + data.blood_group_id;
            // document.getElementById("addressDetail").innerHTML = "<strong class='pe-3'>ที่อยู่:</strong> " + "<br>" + data.address_detail;



            // document.getElementById("modalTel").textContent = data.tel || "N/A";
            // document.getElementById("modalIdentifyId").textContent = data.identify_id || "N/A";
            // document.getElementById("modalStatus").textContent = data.status || "N/A";
            // document.getElementById("modalAddressDetail").textContent = data.address_detail || "N/A";

            // เก็บ member_id สำหรับการดาวน์โหลดรายงาน
            // selectedUnitId = unitId;

            // เปิด modal
            const missionDetailModal = new bootstrap.Modal(document.getElementById("missionDetailModal"));
            missionDetailModal.show();

        } catch (error) {
            console.error("Error fetching member details:", error);
            alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
        }
    }
    fetchAndDisplayMission(currentPage)
    window.showMissionDetail = showMissionDetail;
});