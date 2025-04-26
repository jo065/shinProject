let bbs_id = null;
let content_id = null;
let bbs_info = {};


$(document).ready(function () {
    editorInit();
});

function loadBBSInfo(bbs_id) {
    let result = null;

    $.ajax({
        url: `/cms/bbs/getBBSInfo/${bbs_id}`,   // 💬 서버에서 게시판 정보 가져오기
        method: 'GET',
        async:false,
        success: function (response) {
            result = response;
        },
        error: function () {
            Swal.fire('서버 오류로 게시판 정보 조회에 실패했습니다.', '', 'error');
        }
    });

    return result;
}


function editorInit(){
    const {bbs_id, content_id= false} = getQueryParams();

    $("#submitBtn").text("저장");

    // 타이틀 설정
    bbs_info = loadBBSInfo(bbs_id);
    $("#bbs_title").text('>' + bbs_info.bbs_name);
    console.log(bbs_info);



    // 에디터 로딩
    instanceInit();

    if(content_id){
        editMode(content_id);
    }

}

function getImageSrcList() {
    return $('#summernote').next('.note-editor').find('.note-editable img')
        .map(function() {
            return $(this).attr('src');
        }).get();
}

let uploadedImageIds = []; // 💬 업로드된 file_id를 저장하는 배열


let currentImageSrcList = [];
let deletedImageIdList = [];

function instanceInit() {
    $('#summernote').summernote({
        height: 400,
        lang: 'ko-KR',
        toolbar: [
                 ['style', ['style']],
                 ['font', ['fontsize', 'bold', 'underline', 'clear']],
                 ['color', ['color']],
                 ['para', ['ul', 'ol', 'paragraph']],
                 ['table', ['table']],
                 ['insert', ['link', 'picture', 'video']],
                 ['view', ['fullscreen', 'codeview', 'help']]
               ],
        callbacks: {
            onImageUpload: function(files) {
                for (let i = 0; i < files.length; i++) {
                    uploadImage(files[i]);
                }
            },

            onInit: function() {
                        // 초기 이미지 리스트 저장
                        currentImageSrcList = getImageSrcList();
                    },
                    onChange: function(contents, $editable) {
                        const newImageSrcList = getImageSrcList();

                        // 삭제된 이미지 탐지
                        const deletedImages = currentImageSrcList.filter(src => !newImageSrcList.includes(src));

                        if (deletedImages.length > 0) {
                            console.log('🗑 삭제된 이미지들:', deletedImages);
                            deletedImages.forEach(src => {
                                // fileId 추출하거나 리스트업
                                const match = src.match(/\/cms\/cdn\/img\/(\d+)/);
                                if (match && match[1]) {
                                    const fileId = match[1];
                                    console.log('🆔 삭제된 파일 ID:', fileId);
                                    deletedImageIdList.push(Number.parseInt(fileId));
                                }
                            });
                        }

                        // 현재 리스트 갱신
                        currentImageSrcList = newImageSrcList;
                    }


        }
    });
}


function uploadImage(file) {
    const formData = new FormData();
    formData.append('filepond', file); // 💬 filepond로 맞춰야 함!
    formData.append('mode', 1);         // 💬 mode 기본값 1 추가 (너 코드 참고)

    $.ajax({
        url: '/cms/api/uploadImage', // 너가 만든 API
        method: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            if (response && response.file_id) {

                uploadedImageIds.push(response.file_id);
                // file_id로 최종 URL 만들기
                const imageUrl = `/cms/cdn/img/${response.file_id}`;

                // 에디터에 이미지 삽입
                $('#summernote').summernote('insertImage', imageUrl, function($image) {
                    $image.css('max-width', '100%');
                });
            } else {
                Swal.fire('이미지 업로드 실패', '', 'error');
            }
        },
        error: function() {
            Swal.fire('이미지 업로드 중 오류 발생', '', 'error');
        }
    });
}




function editMode(cid){

    // 전역 바인딩
    content_id = Number.parseInt(cid);

    $("#submitBtn").text("수정");


     $.ajax({
            url: `/cms/bbs/getContent/${content_id}`,
            method: 'GET',
            success: function(res) {
                // 💬 여기서 response 처리는 너가 하면 돼
                const { data = {} } = res

                loadContent(data);

                console.log(data);
            },
            error: function(xhr, status, error) {
                console.error('❌ 컨텐츠 조회 실패', error);
            }
        });

}

function loadContent(data = {}) {
    if (!data || Object.keys(data).length === 0) {
        console.warn('⚠️ 불러올 데이터가 없습니다.');
        return;
    }

    // 제목 입력 세팅
    if (data.title !== undefined) {
        $('#title').val(data.title);
    }

    // 에디터 내용 세팅
    if (data.contents !== undefined) {
        $('#summernote').summernote('code', data.contents);
    }

    console.log('✅ 콘텐츠 불러오기 완료', data);
}




function cancel() {
    if (uploadedImageIds.length > 0) {
        const deletePromises = uploadedImageIds.map(fileId => fileDelete(fileId));

        Promise.all(deletePromises)
            .then(results => {
                console.log('🗑 모든 임시 이미지 삭제 완료:', results);
            })
            .catch(error => {
                console.error('⚠️ 일부 파일 삭제 실패', error);
            });
    }

    history.back(); // 💬 Promise 결과와 상관없이 즉시 이동
}



function fileDelete(fileId) {
    return new Promise((resolve, reject) => {
        $.ajax({
            url: '/cms/api/deleteTempImage',
            method: 'DELETE', // 💬 반드시 DELETE로!
            contentType: 'application/json', // 💬 보내는 타입은 JSON
            data: JSON.stringify(fileId),     // 💬 문자열로 보냄
            success: function() {
                console.log('🗑 서버에서 임시 이미지 삭제 완료:', fileId);
                resolve(fileId);
            },
            error: function(xhr, status, error) {
                console.error('❌ 임시 이미지 삭제 실패:', fileId, error);
                reject(error);
            }
        });
    });
}



function getQueryParams() {
    const params = {};
    const queryString = window.location.search; // ?menu=editor&bbs_id=5&content_id=18

    if (queryString) {
        const urlParams = new URLSearchParams(queryString);
        for (const [key, value] of urlParams.entries()) {
            params[key] = value;
        }
    }
    return params;
}

function saveContent() {
    const bbs_id = bbs_info.bbs_id;          // 숨겨진 input에서 bbs_id 가져오기
    const title = $('#title').val();             // 제목 input
    const contentHtml = $('#summernote').summernote('code'); // 에디터 HTML

    if (!title) {
            Swal.fire('⚠️ 제목을 입력해주세요.', '', 'warning');
            return;
        }

    if (!contentHtml || contentHtml === '<p><br></p>') {
            Swal.fire('⚠️ 본문 내용을 입력해주세요.', '', 'warning');
            return;
    }




    const data = {
        bbs_id: bbs_id,
        title: title,
        contents: contentHtml
    };

    if(content_id){
        updateContent(data);
    }else{
        insertContent(data);
    }





    console.log('📄 저장할 HTML 내용:', contentHtml);
}

function updateContent(data) {

    const concatenated = uploadedImageIds.join(',');

    data.appened_img = concatenated;

    data.content_id = content_id;

    $.ajax({
        url: '/cms/api/updateContent',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function (res) {
            if (res.success) {
                const deletePromises = deletedImageIdList.map(fileId => fileDelete(fileId));

                Promise.all(deletePromises)
                    .then(results => {
                        console.log('🗑 모든 임시 이미지 삭제 완료:', results);

                        // 👉 파일 삭제가 끝난 후에 Swal 보여줌
                        Swal.fire('✅ 수정 완료', '', 'success')
                            .then((result) => {
                                if (result.isConfirmed) {
                                    moveToManagePage();
                                }
                            });

                        // 또는 일정 시간 후 자동 이동
                        setTimeout(() => {
                            moveToManagePage();
                        }, 1500);

                    })
                    .catch(error => {
                        console.error('⚠️ 일부 파일 삭제 실패', error);

                        // 실패했어도 수정 완료는 띄우고 이동은 가능하게 할건지 결정
                        Swal.fire('✅ 수정 완료 (일부 이미지 삭제 실패)', '', 'warning')
                            .then((result) => {
                                if (result.isConfirmed) {
                                    moveToManagePage();
                                }
                            });
                    });
            } else {
                Swal.fire('⚠️ 등록 실패', '잠시 후 다시 시도해주세요.', 'error');
            }
        },
        error: function () {
            Swal.fire('❌ 서버 오류', '잠시 후 다시 시도해주세요.', 'error');
        }
    });
}


function insertContent(data){

 const concatenated = uploadedImageIds.join(',');

data.appened_img= concatenated;

 $.ajax({
        url: '/cms/api/insertContent',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function (res) {
            if (res.success) {
                Swal.fire('✅ 등록 완료', '', 'success')
                    .then((result) => {
                        if (result.isConfirmed) {
                            moveToManagePage();
                         }
                    });

                setTimeout(() => {
                    moveToManagePage();
                }, 1500);
            } else {
                Swal.fire('⚠️ 등록 실패', '잠시 후 다시 시도해주세요.', 'error');
            }
        },
        error: function () {
            Swal.fire('❌ 서버 오류', '잠시 후 다시 시도해주세요.', 'error');
        }
    });
}


function moveToManagePage() {
    const bbsId = bbs_info.bbs_id; // 들고 있는 bbs_id 사용
    location.href = `/cms/admin?menu=manage&bbs_id=${bbsId}`;
}
