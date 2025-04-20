function common(){
	console.log('common');
}


function getContentsList(bbs_id) {
  $.ajax({
    url: `/cms/bbs/getContentsList/${bbs_id}`,
    method: "GET",
    dataType: "json",
    success: function (res) {

      let list = res.data || [];

      list = list.map(item => {
              return {
                ...item,
                imageUrl: `/cms/cdn/img/${item.file_id}`
              };
      });

      console.log(list);


      return list;
    },
    error: function (xhr, status, error) {
      console.error("콘텐츠 목록 조회 실패:", error);
      return [];
    }
  });
}