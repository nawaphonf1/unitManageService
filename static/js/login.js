document.getElementById("loginForm").addEventListener("submit", function (event) {
    event.preventDefault();

    // ดึงค่าจาก input
    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    // สร้าง FormData และเพิ่มค่าที่ได้จาก input
    const formData = new FormData();
    formData.append("username", username);
    formData.append("password", password);

    // ใช้ fetch เพื่อส่งข้อมูลแบบ FormData
    fetch('/api/auth/', {
        method: 'POST',
        body: formData,  // ส่ง formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.access_token) {
            // เก็บ token ใน cookie
            document.cookie = `access_token=${data.access_token}; path=/; domain=192.168.1.133; max-age=3600`;// กำหนดให้ cookie หมดอายุใน 1 ชั่วโมง
            window.location.href = '/mission';  // ถ้าผ่านให้ไปหน้า index.html
        } else {
            document.getElementById("alert").classList.remove("d-none");
        }
    })
    .catch(error => {
        console.error('Error:', error);
    });
});
