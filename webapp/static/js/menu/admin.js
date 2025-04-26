let g_menu02 = {};

$(document).ready(function () {

});

function authenticateAdmin() {
     const input = document.getElementById('admin_pw');
        console.log("input 요소:", input);            // null이면 접근 실패
        console.log("입력한 비밀번호:", input?.value); // undefined나 빈값이면 접근 실패

        const password = input?.value;


    fetch('/menu/auth/admin-check', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ password }),
        credentials: 'include'
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            Swal.fire({
                title: "인증 성공",
                text: "관리자 인증이 완료되었습니다.",
                icon: "success",
                confirmButtonText: "확인"
            }).then(() => {
                window.location.href = '/menu/boardReg.do';
            });
        } else {
            Swal.fire({
                title: "인증 실패",
                text: "비밀번호가 틀렸습니다.",
                icon: "error",
                confirmButtonText: "확인"
            });
        }
    })
    .catch(err => {
        console.error(err);
        Swal.fire({
            title: "오류 발생",
            text: "서버와 통신 중 문제가 발생했습니다.",
            icon: "warning",
            confirmButtonText: "확인"
        });
    });
}
