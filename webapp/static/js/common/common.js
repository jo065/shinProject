function common(){
	console.log('common');
}


function getContentsList(bbs_id) {
  return new Promise((resolve, reject) => {
    $.ajax({
      url: `/cms/bbs/getContentsList/${bbs_id}`,
      method: "GET",
      dataType: "json",
      success: function (res) {
        let list = res.data || [];

        list = list.map(item => ({
          ...item,
          imageUrl: `/cms/cdn/img/${item.file_id}`
        }));

        console.log(list);
        resolve(list); // ✅ 성공시 resolve
      },
      error: function (xhr, status, error) {
        console.error("콘텐츠 목록 조회 실패:", error);
        reject(error); // ✅ 실패시 reject
      }
    });
  });
}



function getCounter() {
  return new Promise((resolve, reject) => {
    $.ajax({
      url: `/cms/api/getCounter`,
      method: "GET",
      success: function (res) {

      const {data}  = res;

        // HTML 문자열 생성
        const html = `
          <span>📅 오늘 날짜: <strong>${data.today}</strong></span>
          <span>👁️ 오늘 접속자 수: <strong>${data.today_cnt}</strong>명</span>
          <span>📊 누적 접속자 수: <strong>${data.total_cnt}</strong>명</span>
        `;

        // 특정 div에 삽입
        $('#visitor-stats').html(html);


        console.log(data);
        resolve(data); // ✅ 성공시 resolve
      },
      error: function (xhr, status, error) {
        console.error("카운터 조회 실패:", error);
        reject(error); // ✅ 실패시 reject
      }
    });
  });
}
