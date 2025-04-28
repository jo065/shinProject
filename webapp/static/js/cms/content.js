
let g_content = {};

$(document).ready(function () {
  let content_id = $("#content_id").val();
  content_id = Number.parseInt(content_id);
  loadContent(content_id);
});

function loadContent(content_id){
    $.ajax({
            url: `/cms/bbs/getContent/${content_id}`,
            method: 'GET',
            success: function(res) {
                // 💬 여기서 response 처리는 너가 하면 돼
                const { data = {} } = res

                g_content = data;
                console.log(g_content);

                renderContent(g_content);
            },
            error: function(xhr, status, error) {
                console.error('❌ 컨텐츠 조회 실패', error);
            }
        });
}

function renderContent(data){

    console.log('render', data);

     $.ajax({
            url: `/cms/api/getCateInfo/${data.cat_id}`,   // 💬 서버에서 게시판 정보 가져오기
            method: 'GET',
            success: function (response) {
                const {data} = response;
                console.log('catedata', data);
                $("#content-cate").text(data.cat_label || 미분류);
            },
            error: function () {
                Swal.fire('서버 오류로 게시판 정보 조회에 실패했습니다.', '', 'error');
            }
    });



    $("#content-title").html(data.title);
    $("#content-regdt").html(formatRegDt(data.reg_dt));
    $("#content").html(data.contents);


}

function formatRegDt(regDtStr) {
    if (!regDtStr) return '';

    const date = new Date(regDtStr); // 문자열을 Date 객체로 변환

    if (isNaN(date.getTime())) {
        console.error('❌ 잘못된 날짜 포맷:', regDtStr);
        return '';
    }

    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0'); // 월은 0부터 시작
    const day = date.getDate().toString().padStart(2, '0');

    return `${year}-${month}-${day}`;
}
