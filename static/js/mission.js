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
                    <button class="btn btn-warning btn-sm" data-id="${mission.mission_id}" onclick="showMissionEdit(${mission.mission_id})">แก้ไข</button>

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

async function showMissionUnitTableBody(missionId){
    try {
        const response = await fetch(`/api/mission/mission_units/${missionId}`, {
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
        const tableBody = document.getElementById("missionUnitTableBody");

        tableBody.innerHTML = ""; // Clear existing rows
        let indexss = 1;

        // Populate the table
        data.forEach((mission, index) => {
            const row = document.createElement("tr");


            row.innerHTML = `
                <td>${indexss}</td>
                <td>${mission.position_name_short || "N/A"}</td>
                <td>${mission.first_name}</td>
                <td>${mission.last_name}</td>
            `;
            tableBody.appendChild(row);
            indexss += 1;
        });
        

    } catch (error) {
        console.error("Error fetching showMissionUnitTableBody:", error);
        alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
    }
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
            const missionStartDate = formatDateToThai(data.mission_start);
            const missionEndDate = formatDateToThai(data.mission_end);
            let missionStatus = data.mission_status;
            if (data.mission_status == 'r') {
            missionStatus = "กำลังดำเนินการ";
            } else {
            missionStatus = "ดำเนินการเสร็จสิ้น";
            }
            // แสดงข้อมูลใน modal
            document.getElementById('missionDetailName').value = data.mission_name || '';
            document.getElementById('missionDetailDateStart').value = missionStartDate || '';
            document.getElementById('missionDetailDateEnd').value = missionEndDate || '';
            document.getElementById('missionDetail').value = data.mission_detail || '';
            document.getElementById('missiontypeDetail').value = data.mission_type || '';
            document.getElementById('missionStatusDetail').value = missionStatus || '';

            // เก็บ member_id สำหรับการดาวน์โหลดรายงาน
            // selectedUnitId = unitId;

            showMissionUnitTableBody(missionId);

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

// ------------------------------------------------------------------------------ Edit Model
async function showMissionEdit(missionId) {
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
        const missionStartDate = formatDateToThai(data.mission_start);
        const missionEndDate = formatDateToThai(data.mission_end);
        let missionStatus = data.mission_status;
        if (data.mission_status == 'r') {
        missionStatus = "กำลังดำเนินการ";
        } else {
        missionStatus = "ดำเนินการเสร็จสิ้น";
        }
        // แสดงข้อมูลใน modal
        document.getElementById('missionEditName').value = data.mission_name || '';
        document.getElementById('missionEditName').setAttribute('data-mission-id', data.mission_id);

        document.getElementById('missionEditDateStart').value = data.mission_start || '';
        document.getElementById('missionEditDateEnd').value = data.mission_end || '';
        document.getElementById('missionDetailEdit').value = data.mission_detail || '';
        document.getElementById('missiontypeEdit').value = data.mission_type || '';
        document.getElementById('missionStatusEdit').value = missionStatus || '';

        // เก็บ member_id สำหรับการดาวน์โหลดรายงาน
        // selectedUnitId = unitId;

        // showMissionUnitTableBody(missionId);
        showMissionUnitEditTableBody(missionId)
        addUnitFromEditModel();

        // เปิด modal
        const missionEditModal = new bootstrap.Modal(document.getElementById("missionEditModal"));
        missionEditModal.show();

    } catch (error) {
        console.error("Error fetching member details:", error);
        alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
    }
}

async function showMissionUnitEditTableBody(missionId){
    try {
        const response = await fetch(`/api/mission/mission_units/${missionId}`, {
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
        const tableBody = document.getElementById("missionUnitEditTableBody");

        tableBody.innerHTML = ""; // Clear existing rows
        let indexss = 1;

        // Populate the table
        data.forEach((mission, index) => {
            const row = document.createElement("tr");

            row.innerHTML = `
                <td>${indexss}</td>
                <td>${mission.position_name_short || "N/A"}</td>
                <td>${mission.first_name}</td>
                <td>${mission.last_name}</td>
                <td>
                    <button class="btn btn-danger btn-sm" data-edit-mission-unit-id="${mission.units_id}" onclick="delUnitFormTableEdit(${mission.units_id})">-</button>
                </td>
            `;
            tableBody.appendChild(row);
            indexss += 1;
        });
        

    } catch (error) {
        console.error("Error fetching showMissionUnitTableBody:", error);
        alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
    }
}

async function addUnitFromEditModel(position_id = '', first_name = '', last_name = '') {
    try {
        const queryParams = new URLSearchParams();
        if (position_id) {
            queryParams.append("position_id", position_id);
        }
        if (first_name) {
            queryParams.append("first_name", first_name);
        }
        if (last_name) {
            queryParams.append("last_name", last_name);
        }
        
        const response = await fetch(`/api/unit/units_ready?${queryParams.toString()}`, {
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
        const tableBody = document.getElementById("addUnitFromEditModelTableBody");

        tableBody.innerHTML = ""; // Clear existing rows
        let indexss = 1;

        // Populate the table with select boxes
        data.forEach((unit, index) => {
            const row = document.createElement("tr");

            row.innerHTML = `
                <td>
                    <input type="checkbox" data-unit-id="${unit.units_id}">
                </td>
                <td>${unit.position_name_short || "N/A"}</td>
                <td>${unit.first_name}</td>
                <td>${unit.last_name}</td>
            `;
            tableBody.appendChild(row);
            indexss += 1;
        });

        positionDropdown();
    } catch (error) {
        console.error("Error fetching showMissionUnitTableBody:", error);
        alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
    }
}

async function positionDropdown(){
    // โหลดข้อมูลตำแหน่งจาก API
    const positionResponse = await fetch(`/api/position`, {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${token}`
        }
    });

    if (!positionResponse.ok) {
        throw new Error("Failed to fetch positions.");
    }

    const positions = await positionResponse.json();

    const filterPositionAddUnitModel = document.getElementById("filterPositionAddUnitModel");

    // เก็บค่าที่เลือกไว้ก่อนหน้านี้ (ถ้ามี)
    const previousValue = filterPositionAddUnitModel.value;

    filterPositionAddUnitModel.innerHTML = ""; // ลบตัวเลือกเก่า
    const option2 = document.createElement("option");
    option2.value = '';
    option2.textContent = '';

    filterPositionAddUnitModel.appendChild(option2);
    positions.forEach(position => {  
        const option2 = document.createElement("option");
        option2.value = position.position_id;
        option2.textContent = position.position_name;

        // ตั้งค่า selected หากตรงกับค่าที่เลือกไว้ก่อนหน้า
        if (position.position_id.toString() === previousValue) {
            option2.selected = true;
        }

        filterPositionAddUnitModel.appendChild(option2);
    });
}

document.getElementById("confirmAddUnitEdit").addEventListener("click", () => {
    const selectedUnits = [];
    const checkboxes = document.querySelectorAll('#addUnitFromEditModelTableBody input[type="checkbox"]:checked');

    checkboxes.forEach((checkbox) => {
        const unitId = checkbox.getAttribute("data-unit-id");
        const row = checkbox.closest("tr");
        const position = row.children[1].innerText;
        const firstName = row.children[2].innerText;
        const lastName = row.children[3].innerText;

        selectedUnits.push({ unitId, position, firstName, lastName });
    });

    const tableBody = document.getElementById("missionUnitEditTableBody");

    selectedUnits.forEach((unit, index) => {
        const row = document.createElement("tr");

        row.innerHTML = `
            <td>${tableBody.children.length + 1}</td>
            <td>${unit.position}</td>
            <td>${unit.firstName}</td>
            <td>${unit.lastName}</td>
            <td>
                <button class="btn btn-danger btn-sm" data-edit-mission-unit-id="${unit.unitId}" onclick="deleteRow(this)">-</button>
            </td>
        `;

        tableBody.appendChild(row);
    });

    // Close the modal
    document.querySelector("#addUnitFromEditModel .btn-close").click();
});

document.getElementById("submitFilterAddUnitModel").addEventListener("click", () => {
    const positionId = document.getElementById("filterPositionAddUnitModel").value;
    const firstName = document.getElementById("filterfirstNameAddUnitModel").value;
    const LastName = document.getElementById("filterLastNameAddUnitModel").value;

    addUnitFromEditModel(positionId, firstName, LastName);
});

// Function to delete a row
function deleteRow(button) {
    const row = button.closest("tr");
    row.remove();
}


function delUnitFormTableEdit(unitId) {
    // ค้นหาแถวที่มีปุ่มที่ถูกกด
    const button = document.querySelector(`button[data-edit-mission-unit-id="${unitId}"]`);
    const row = button.closest("tr"); // หาแถวที่ใกล้ที่สุดของปุ่ม
    if (row) {
        row.remove(); // ลบแถว
    }
}

document.getElementById("confirmEdit").addEventListener("click", () => {
    const tableBody = document.getElementById("missionUnitEditTableBody");
    const rows = tableBody.querySelectorAll("tr"); // ดึงทุกแถวในตาราง
    const missionUnits = [];

    rows.forEach((row) => {
        const unitId = row.querySelector("button")?.getAttribute("data-edit-mission-unit-id") || ""; // ดึง unit_id จาก attribute ปุ่ม (ถ้ามี)
        if (unitId) {
            missionUnits.push(parseInt(unitId)); // แปลงค่าของ unitId ให้เป็นตัวเลข
        }
    });

    const missionId = parseInt(document.getElementById("missionEditName").getAttribute('data-mission-id')); // แปลง missionId เป็น int
    const missionEditName = document.getElementById("missionEditName").value;
    const missionEditDateStart = document.getElementById("missionEditDateStart").value; // รูปแบบที่ถูกต้องคือ 'YYYY-MM-DD'
    const missionEditDateEnd = document.getElementById("missionEditDateEnd").value; // รูปแบบที่ถูกต้องคือ 'YYYY-MM-DD'
    const missionDetailEdit = document.getElementById("missionDetailEdit").value;
    const missiontypeEdit = document.getElementById("missiontypeEdit").value;
    const missionStatusEdit = "ready";

    // ตรวจสอบข้อมูลก่อนส่ง
    if (!missionEditName || !missionEditDateStart || !missionEditDateEnd || missionUnits.length === 0) {
        alert("กรุณากรอกข้อมูลให้ครบถ้วน!");
        return;
    }

    const data = {
        missionId: missionId,
        mission_name: missionEditName,
        mission_start: missionEditDateStart,
        mission_end: missionEditDateEnd,
        mission_detail: missionDetailEdit,
        mission_type: missiontypeEdit,
        mission_status: missionStatusEdit,
        is_active: true,
        mission_unit_id: missionUnits
    };

    console.log(missionUnits);

    // ตรวจสอบ token
    if (!token) {
        alert("กรุณาเข้าสู่ระบบใหม่");
        return;
    }

    // ส่งข้อมูลไปยัง API
    fetch(`/api/mission/update_mission_units/${missionId}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}` // แทนที่ด้วย token ของคุณ
        },
        body: JSON.stringify(data)
    })
        .then(response => {
            if (response.ok) {
                alert("อัปเดตข้อมูลสำเร็จ!");
                location.reload();
            } else {
                return response.json().then(err => {
                    console.error("Error response:", err);
                    alert("เกิดข้อผิดพลาดในการอัปเดตข้อมูล!");
                });
            }
        })
        .catch(error => {
            console.error("Error updating mission units:", error);
            alert("เกิดข้อผิดพลาดในการส่งข้อมูล!");
        });
});


// ---------------------------------------------------------------------------