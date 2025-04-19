let g_reg = {};

$(document).ready(function () {
    initTable();


    document.getElementById('upload_file').addEventListener('change', function (event) {
        const file = event.target.files[0];
        const preview = document.getElementById('preview_image');

        if (file && file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        } else {
            preview.src = '#';
            preview.style.display = 'none';
        }
    });
});

function openPostForm() {
    document.getElementById('post-modal').style.display = 'flex';
}

function closePostForm() {
    document.getElementById('post-modal').style.display = 'none';
}

document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('post-form');

    form.addEventListener('submit', function (e) {
        e.preventDefault();

        const formData = new FormData(form);

        // 예시: 콘솔로 확인 (실제로는 서버에 POST 요청)
        console.log("게시판 이름:", formData.get('bbs_name'));
        console.log("파일:", formData.get('upload_file'));

        // 서버 전송 예시 (fetch로 서버에 파일 포함 전송 가능)
        // fetch('/api/board/upload', {
        //     method: 'POST',
        //     body: formData
        // }).then(response => response.json())
        //   .then(result => console.log(result));

        alert("게시글이 등록되었습니다 (가상 처리)");
        form.reset();
        closePostForm();
    });
});


function initTable() {
    // 테이블을 초기화하고 생성
    var table = new Tabulator("#board-table", {
        height: "311px", // 테이블 높이 설정
        layout: "fitColumns", // 열 너비를 자동으로 맞춤
        columns: [
            {
            title: "게시판 ID",
            field: "bbs_id",
            sorter: "number",
            hozAlign: "right"
            },
            {
            title: "게시판 이름",
            field: "bbs_name",
            sorter: "string"
            },
            {
            title: "게시판 타입",
            field: "bbs_type",
            sorter: "string",
            hozAlign: "center"
            },
            {
            title: "사용 여부",
            field: "use_yn",
            sorter: "string",
            hozAlign: "center"
            },
            {
            title: "등록자",
            field: "reg_id",
             sorter: "string"
             },
            {
            title: "등록일",
            field: "reg_dt",
            sorter: "date",
            hozAlign: "center"
            },
            {
            title: "수정자",
            field: "mod_id",
            sorter: "string"
            },
            {
            title: "수정일",
            field: "mod_dt",
            sorter: "date",
            hozAlign: "center"
            },
        ],
        data: [ // 가짜 데이터 (Mock Data)
            {
                bbs_id: 1,
                bbs_name: "공지사항",
                bbs_type: "공지",
                use_yn: "Y",
                reg_id: "admin",
                reg_dt: "2025-04-01",
                mod_id: "admin",
                mod_dt: "2025-04-15"
            },
            {
                bbs_id: 2,
                bbs_name: "자유게시판",
                bbs_type: "일반",
                use_yn: "Y",
                reg_id: "user1",
                reg_dt: "2025-03-20",
                mod_id: "user2",
                mod_dt: "2025-04-10"
            },
            {
                bbs_id: 3,
                bbs_name: "질문답변",
                bbs_type: "QnA",
                use_yn: "N",
                reg_id: "user3",
                reg_dt: "2025-02-10",
                mod_id: "admin",
                mod_dt: "2025-02-15"
            }
        ],
    });
}
