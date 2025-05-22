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
