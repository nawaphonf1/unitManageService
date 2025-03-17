function getCookie(name) {
    let cookies = document.cookie.split("; ");
    for (let cookie of cookies) {
        let [key, value] = cookie.split("=");
        if (key === name) {
            return decodeURIComponent(value); // ถอดรหัสค่าเผื่อมีอักขระพิเศษ
        }
    }
    return null;
}

// เรียกใช้ฟังก์ชัน
let token = getCookie("access_token");
let role = getCookie("role");

console.log("Token:", token);
console.log("Role:", role);


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
async function fetchAndDisplayMission(page = 1, mission_name = "", mission_start= "", mission_end= "", mission_type= "", mission_status= "") {
    try {
        // สร้าง query string เฉพาะพารามิเตอร์ที่มีค่า
        const queryParams = new URLSearchParams();
        queryParams.append("skip", (page - 1) * rowsPerPage);
        queryParams.append("limit", rowsPerPage);

        // console.log(name);

        if (mission_name) {
            queryParams.append("mission_name", mission_name);
        }
        if (mission_start) {
            queryParams.append("mission_start", mission_start);
        }
        if (mission_end) {
            queryParams.append("mission_end", mission_end);
        }
        if (mission_type) {
            queryParams.append("mission_type", mission_type);
        }
        if (mission_status) {
            queryParams.append("mission_status", mission_status);
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
        const tableBody = document.getElementById("missionTableBody");
        const pagination = document.getElementById("pagination");

        tableBody.innerHTML = ""; // Clear existing rows

        // Populate the table
        data.missions.forEach((mission, index) => {
            let statusColor = null;
            if (mission.mission_status == 'r') {
                statusColor = "green";
            }
            else if (mission.mission_status == 'w') {
                statusColor = "yellow";
            }
            else
            {
                statusColor = "red";
            }
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
                    ${role === "admin" ? `<button class="btn btn-warning btn-sm" data-id="${mission.mission_id}" onclick="showMissionEdit(${mission.mission_id})">แก้ไข</button>` : ""}
                    ${role === "admin" ? `<button class="btn btn-danger btn-sm" data-id="${mission.mission_id}" onclick="delMission(${mission.mission_id})">ลบ</button>` : ""}                    
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
function updatePagination(totalPages, currentPage) {
    const pagination = document.getElementById("pagination");
    pagination.innerHTML = ""; // Clear existing pagination

    const mission_name = document.getElementById("filterMissionName").value;
    const mission_start = document.getElementById("filterDateStartM").value;
    const mission_end = document.getElementById("filterDateEndM").value;
    const mission_type = document.getElementById("filterMissionTypeM").value;
    const mission_status = document.getElementById("filterStatusM").value;


    for (let page = 1; page <= totalPages; page++) {
        const li = document.createElement("li");
        li.className = `page-item ${page === currentPage ? "active" : ""}`;
        li.innerHTML = `
            <a class="page-link" href="#">${page}</a>
        `;
        li.addEventListener("click", (event) => {
            event.preventDefault();
            fetchAndDisplayMission(page, mission_name, mission_start, mission_end, mission_type, mission_status);
        });
        pagination.appendChild(li);
    }
}

document.getElementById("submit-filter-mission").addEventListener("click", () => {
    const mission_name = document.getElementById("filterMissionName").value;
    const mission_start = document.getElementById("filterDateStartM").value;
    const mission_end = document.getElementById("filterDateEndM").value;
    const mission_type = document.getElementById("filterMissionTypeM").value;
    const mission_status = document.getElementById("filterStatusM").value;

    fetchAndDisplayMission(1, mission_name, mission_start, mission_end, mission_type, mission_status);

    const filterModal = bootstrap.Modal.getInstance(document.getElementById("filterModal"));
    filterModal.hide();
});

async function delMission(missionId){
    try {
        const response = await fetch(`/api/mission/${missionId}`, {
            method: "DELETE",
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

        if (response.ok) {
            alert("ลบภารกิจเสร็จสิน");
            location.reload(); // Replace '/' with your homepage URL
            return;
        }

    } catch (error) {
        console.error("Error fetching showMissionUnitTableBody:", error);
        alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
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
            } else if(data.mission_status == 'w'){
                missionStatus = "รอดำเนินการ";

            }
            else {
                missionStatus = "ดำเนินการเสร็จสิ้น";
            }
            // แสดงข้อมูลใน modal
            document.getElementById('missionDetailName').value = data.mission_name || '';
            document.getElementById('missionDetailName').setAttribute("data-mission-id", data.mission_id) ;

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

    if (role !== "admin") {
        const addMissionBtn = document.getElementById("addMissionBtn");
        if (addMissionBtn) {
            addMissionBtn.remove();  // ลบปุ่มออกจาก DOM
        }

        const user_manage = document.getElementById("user_manage");
        if (user_manage) {
            user_manage.remove();  // ลบปุ่มออกจาก DOM
        }

    }
    
    
    console.log("DOMContentLoaded");
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
        } else if(data.mission_status == 'w'){
            missionStatus = "รอดำเนินการ";

        }
        else {
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


// -------------------------------------------Add-----------------------------
document.getElementById("addUnitFromAddModel2").addEventListener("click", (event) => {
    const date_start = document.getElementById("missionAddDateStart").value;
    const date_end = document.getElementById("missionAddDateEnd").value;

    if (date_start === '' || date_end === '') {
        alert("กรุณากรอกวันที่เริ่มและสิ้นสุดภารกิจ");

        // หยุดการทำงานของ event เพื่อไม่ให้เปิด modal
        event.preventDefault();
    } else {
        // แสดงข้อมูลเพิ่มเติมใน modal
        showDataAddUnitFromAddModel();
    }
});
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

        date_start = document.getElementById("missionEditDateStart").value;
        date_end = document.getElementById("missionEditDateEnd").value;

        queryParams.append("date_start", date_start);
        queryParams.append("date_end", date_end);
        
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
        console.error("Error fetching addUnitFromAddModelTableBody:", error);
        alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
    }

    
    
}

async function showDataAddUnitFromAddModel(position_id = '', first_name = '', last_name = '') {
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
        

        date_start = document.getElementById("missionAddDateStart").value;
        date_end = document.getElementById("missionAddDateEnd").value;

        queryParams.append("date_start", date_start);
        queryParams.append("date_end", date_end);
        
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
        const tableBody = document.getElementById("addUnitFromAddModelTableBody");

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
        console.error("Error fetching addUnitFromAddModelTableBody:", error);
        alert("เกิดข้อผิดพลาดในการโหลดข้อมูลสมาชิก");
    }

    
    
}
document.getElementById("confirmAddUnitAdd").addEventListener("click", () => {
    const selectedUnits = [];
    const checkboxes = document.querySelectorAll('#addUnitFromAddModelTableBody input[type="checkbox"]:checked');

    checkboxes.forEach((checkbox) => {
        const unitId = checkbox.getAttribute("data-unit-id");
        const row = checkbox.closest("tr");
        const position = row.children[1].innerText;
        const firstName = row.children[2].innerText;
        const lastName = row.children[3].innerText;

        selectedUnits.push({ unitId, position, firstName, lastName });
    });

    const tableBody = document.getElementById("missionUnitAddTableBody");

    // ดึง unitId ทั้งหมดที่มีอยู่แล้วใน tableBody
    const existingUnitIds = Array.from(tableBody.querySelectorAll("button[data-edit-mission-unit-id]"))
        .map(button => button.getAttribute("data-edit-mission-unit-id"));

    selectedUnits.forEach((unit) => {
        // ตรวจสอบว่า unitId มีอยู่ใน tableBody หรือยัง
        if (!existingUnitIds.includes(unit.unitId)) {
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
        }
    });

    // Close the modal
    document.querySelector("#addUnitFromAddModel .btn-close").click();
});
document.getElementById("addMissionNewUnits").addEventListener("click", () => {
    const tableBody = document.getElementById("missionUnitAddTableBody");
    const rows = tableBody.querySelectorAll("tr"); // ดึงทุกแถวในตาราง
    const missionUnits = [];

    rows.forEach((row) => {
        const unitId = row.querySelector("button")?.getAttribute("data-edit-mission-unit-id") || ""; // ดึง unit_id จาก attribute ปุ่ม (ถ้ามี)
        if (unitId) {
            missionUnits.push(parseInt(unitId)); // แปลงค่าของ unitId ให้เป็นตัวเลข
        }
    });

    const missionAddName = document.getElementById("missionAddName").value;
    const missionAddDateStart = document.getElementById("missionAddDateStart").value; // รูปแบบที่ถูกต้องคือ 'YYYY-MM-DD'
    const missionAddDateEnd = document.getElementById("missionAddDateEnd").value; // รูปแบบที่ถูกต้องคือ 'YYYY-MM-DD'
    const missionDetailAdd = document.getElementById("missionDetailAdd").value;
    const missiontypeAdd = document.getElementById("missiontypeAdd").value;
    const missionStatusAdd = "ready";

    // ตรวจสอบข้อมูลก่อนส่ง
    if (!missionAddName || !missionAddDateStart || !missionAddDateEnd || missionUnits.length === 0) {
        alert("กรุณากรอกข้อมูลให้ครบถ้วน!");
        return;
    }

    const data = {
        mission_name: missionAddName,
        mission_start: missionAddDateStart,
        mission_end: missionAddDateEnd,
        mission_detail: missionDetailAdd,
        mission_type: missiontypeAdd,
        mission_status: missionStatusAdd,
        is_active: true,
        mission_unit_id: missionUnits
    };

    console.log(data)


    // ตรวจสอบ token
    if (!token) {
        alert("กรุณาเข้าสู่ระบบใหม่");
        return;
    }

    // ส่งข้อมูลไปยัง API
    fetch(`/api/mission/`, {
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
// -------------------------------------------Add-----------------------------


document.getElementById('exportExcelMission').addEventListener('click', async () => {
    const missionId = document.getElementById('missionDetailName').getAttribute('data-mission-id');
    const missionName = document.getElementById('missionDetailName').value;

    try {
        // เรียก API เพื่อดึงไฟล์ Excel
        const response = await fetch(`/api/mission/export_mission/${missionId}`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}` // ใช้ token ในการยืนยันตัวตน
            }
        });

        if (response.status === 401) {
            alert('Session expired. Please login again.');
            window.location.href = '/login'; // Redirect ไปยังหน้า login หาก session หมดอายุ
            return;
        }

        if (!response.ok) {
            throw new Error('Failed to export mission data.');
        }

        // รับไฟล์จาก response
        const blob = await response.blob();
        const url = window.URL.createObjectURL(blob);

        // สร้างลิงก์สำหรับดาวน์โหลด
        const link = document.createElement('a');
        link.href = url;
        link.download = `${missionName}.xlsx`; // ตั้งชื่อไฟล์ที่ต้องการดาวน์โหลด
        document.body.appendChild(link);
        link.click();

        // ลบลิงก์หลังจากดาวน์โหลดเสร็จ
        link.remove();
        window.URL.revokeObjectURL(url);

    } catch (error) {
        console.error('Error exporting mission:', error);
        alert('เกิดข้อผิดพลาดในการดาวน์โหลดไฟล์ Excel');
    }
});


document.getElementById('submit-export-mission-unit').addEventListener('click', async () => {
    try {

        const queryParams = new URLSearchParams();
        
        const filterDateStart = document.getElementById("filterDateStart").value;
        const filterDateEnd = document.getElementById("filterDateEnd").value;
        const filterMissionType = document.getElementById("filterMissionType").value;
        const filterStatus = document.getElementById("filterStatus").value;
        const filterPositionDetail = document.getElementById("filterPositionDetail").value;
        const filterPosition = document.getElementById("filterPosition").value;


        // console.log(name);

        if (filterDateStart != '') {
            queryParams.append("mission_start", filterDateStart);
        }
        if (filterDateEnd != '') {
            queryParams.append("mission_end", filterDateEnd);
        }
        if (filterMissionType != '') {
            queryParams.append("mission_type", filterMissionType);
        }
        if (filterStatus != '') {
            queryParams.append("mission_status", filterStatus);
        }
        if (filterPositionDetail != '') {
            queryParams.append("position_detail", filterPositionDetail);
        }
        if (filterPosition != '') {
            queryParams.append("position_name", filterPosition);
        }



        // เรียก API เพื่อดึงไฟล์ Excel
        const response = await fetch(`/api/missionexport_missions/unit?${queryParams.toString()}`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}` // ใช้ token ในการยืนยันตัวตน
            }
        });

        if (response.status === 401) {
            alert('Session expired. Please login again.');
            window.location.href = '/login'; // Redirect ไปยังหน้า login หาก session หมดอายุ
            return;
        }

        if (!response.ok) {
            throw new Error('Failed to export mission data.');
        }

        // รับไฟล์จาก response
        const blob = await response.blob();
        const url = window.URL.createObjectURL(blob);

        // สร้างลิงก์สำหรับดาวน์โหลด
        const link = document.createElement('a');
        link.href = url;
        link.download = `รายงานภารกิจ.xlsx`; // ตั้งชื่อไฟล์ที่ต้องการดาวน์โหลด
        document.body.appendChild(link);
        link.click();

        // ลบลิงก์หลังจากดาวน์โหลดเสร็จ
        link.remove();
        window.URL.revokeObjectURL(url);

    } catch (error) {
        console.error('Error exporting mission:', error);
        alert('เกิดข้อผิดพลาดในการดาวน์โหลดไฟล์ Excel');
    }
});