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
const apiUrl = "/api/unit/";

// Variables for pagination
let currentPage = 1;
const rowsPerPage = 10;

// Function to fetch and display units
async function fetchAndDisplayUnits(page = 1) {
    try {
        const response = await fetch(`${apiUrl}?skip=${(page - 1) * rowsPerPage}&limit=${rowsPerPage}`, {
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
        const tableBody = document.getElementById("unitTableBody");
        const pagination = document.getElementById("pagination");

        tableBody.innerHTML = ""; // Clear existing rows

        // Populate the table
        data.units.forEach((unit, index) => {
            const statusColor = unit.status === "ready" ? "green" : "red";
            const row = document.createElement("tr");
            console.log(unit);
            row.innerHTML = `
                <td>${(page - 1) * rowsPerPage + index + 1}</td>
                <td>${unit.position_name || "N/A"}</td>
                <td>${unit.first_name} ${unit.last_name}</td>
                <td>${unit.dept_name || "N/A"}</td>
                <td>
                    <span class="status-circle" style="background-color: ${statusColor};"></span> ${unit.status || "Active"}
                </td>
                <td>
                    <button class="btn btn-info btn-sm" data-id="${unit.units_id}" onclick="showMemberDetail(${unit.units_id})">รายละเอียด</button>
                    <button class="btn btn-warning btn-sm" data-id="${unit.units_id}" onclick="editMember(${unit.units_id})">แก้ไข</button>
                </td>

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

async function displayUnitsMission(unitId) {
    try {
        const response = await fetch(`http://127.0.0.1:8000/api/mission/units/${unitId}`, {
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

        tableBody.innerHTML = ""; // Clear existing rows

        let num = 1; // เริ่มต้นตัวแปร num
        data.forEach((mission) => {
            const statusColor = mission.mission_status === "r" ? "green" : "red";

            // แปลงวันที่เริ่มต้นและสิ้นสุดเป็นแบบไทย
            const missionStartDate = formatDateToThai(mission.mission_start);
            const missionEndDate = formatDateToThai(mission.mission_end);

            const row = document.createElement("tr");

            row.innerHTML = `
                <td>${num}</td>
                <td>${mission.mission_name || "N/A"}</td>
                <td>${missionStartDate}</td>
                <td>${missionEndDate}</td>
                <td>
                    <span class="status-circle" style="background-color: ${statusColor};"></span> 
                </td>
            `;
            num += 1; // เพิ่มค่า num
            tableBody.appendChild(row);
        });

        // ฟังก์ชันแปลงวันที่เป็นรูปแบบไทย
        function formatDateToThai(dateString) {
            const date = new Date(dateString);
            const day = date.getDate(); // วันที่
            const month = date.toLocaleString("th-TH", { month: "long" }); // ชื่อเดือนแบบไทย
            const year = date.getFullYear() + 543; // แปลง ค.ศ. เป็น พ.ศ.
            return `${day} ${month} ${year}`;
        }



        // Update pagination
        const totalPages = Math.ceil(data.total / rowsPerPage);
        updatePagination(totalPages, page);
    } catch (error) {
        console.error("Error fetching units:", error);
    }
}

// Function to update pagination
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
            fetchAndDisplayUnits(page);
        });
        pagination.appendChild(li);
    }
}

document.addEventListener("DOMContentLoaded", function () {
    async function showMemberDetail(unitId) {
        try {
            const response = await fetch(`${apiUrl}units/${unitId}`, {
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
            console.log(data);
    
            // แสดงข้อมูลใน modal
            document.getElementById('units-img').src = data.img_path
            // document.getElementById("modalPositionName").textContent = data.position_name;
            document.getElementById("unitDetailName").innerHTML  = "<strong class='pe-3'>ชื่อ:</strong> "+"<br>" + data.position_name +" "+data.first_name + " " + data.last_name;
            document.getElementById("deptDetailName").innerHTML  = "<strong class='pe-3'>สังกัด:</strong> "+"<br>" + data.dept_name;
            document.getElementById("identifyIdDetail").innerHTML  = "<strong class='pe-3'>หมายเลขประจำตัว:</strong> "+"<br>" + data.identify_id;
            document.getElementById("identifySoldierIdDetail").innerHTML  = "<strong class='pe-3'>หมายเลขประจำตัวทหาร:</strong> "+"<br>" + data.identify_soldier_id;
            document.getElementById("telDetail").innerHTML  = "<strong class='pe-3'>เบอร์โทร:</strong> "+"<br>" + data.tel;
            document.getElementById("bloodGroupDetail").innerHTML  = "<strong class='pe-3'>กรุ๊ปเลือด:</strong> "+"<br>" + data.blood_group_id;
            document.getElementById("addressDetail").innerHTML  = "<strong class='pe-3'>ที่อยู่:</strong> "+"<br>" + data.address_detail;
            

            
            // document.getElementById("modalTel").textContent = data.tel || "N/A";
            // document.getElementById("modalIdentifyId").textContent = data.identify_id || "N/A";
            // document.getElementById("modalStatus").textContent = data.status || "N/A";
            // document.getElementById("modalAddressDetail").textContent = data.address_detail || "N/A";
    
            // เก็บ member_id สำหรับการดาวน์โหลดรายงาน
            selectedUnitId = unitId;
    
            // เปิด modal
            const unitDetailModal = new bootstrap.Modal(document.getElementById("unitDetailModal"));
            unitDetailModal.show();
            displayUnitsMission(unitId);
    
        } catch (error) {
            console.error("Error fetching member details:", error);
            alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
        }
    }
    

    fetchAndDisplayUnits(currentPage)
    window.showMemberDetail = showMemberDetail;
    window.displayUnitsMission = displayUnitsMission; // ให้ฟังก์ชันใช้ได้ใน scope ทั่วไป
});


document.getElementById("upload-image-btn").addEventListener("click", async () => {
    const imageInput = document.getElementById("units-image");
    const unitsImg = document.getElementById("units-img");

    if (imageInput.files.length === 0) {
        alert("กรุณาเลือกไฟล์รูปภาพ");
        return;
    }

    const formData = new FormData();
    formData.append("file", imageInput.files[0]);

    try {
        const response = await fetch("http://127.0.0.1:8000/api/unit/upload-image", {
            method: "POST",
            body: formData,
        });

        if (!response.ok) {
            throw new Error("การอัพโหลดล้มเหลว");
        }

        const result = await response.json();
        alert("อัพโหลดรูปภาพสำเร็จ");
        unitsImg.src = result.imageUrl; // ตั้งค่ารูปภาพที่อัพโหลด
    } catch (error) {
        console.error("Error uploading image:", error);
        alert("การอัพโหลดรูปภาพผิดพลาด");
    }
});