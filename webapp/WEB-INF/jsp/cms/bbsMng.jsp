<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link href="${pageContext.request.contextPath}/static/vendor/tabulator/dist/css/tabulator_simple.min.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/vendor/tabulator/dist/js/tabulator.min.js"></script>

<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/cms/CmsMenuMng.js"></script>
<link href="${pageContext.request.contextPath}/static/css/cms/CmsMenu.style.css" rel="stylesheet">

<body>
<h4>게시판 관리</h4>

<div style="padding: 20px; margin: 0 auto;">
  <!-- 상단 버튼 영역 -->
  <div style="margin-bottom: 16px;">
    <button id="btnAddBoard" onclick="bbsAdd()">➕ 게시판 추가</button>
    <button id="btnDeleteBoard" onclick="bbsDel()">🗑️ 선택 삭제</button>
  </div>

  <!-- 테이블 영역 -->
  <div id="boardTable" style="width:60%"></div>
</div>

<script>
  let boardTable;

  $(document).ready(function () {
    boardTable = new Tabulator("#boardTable", {
      layout: "fitColumns",
      height: 400,
      selectable: true,
      placeholder: "등록된 게시판이 없습니다.",
      ajaxURL: "/cms/api/boardList",   // ✅ 게시판 목록 가져오는 API
      ajaxConfig: "GET",
      columns: [
        { title: "", formatter: "rowSelection", hozAlign: "center", headerSort: false, width: 50 },

        {
          title: "게시판 유형",
          field: "bbs_type",
          headerHozAlign: "center",
          width: 150,
          formatter: function(cell){
           const value = cell.getValue();
               const typeMap = {
                 "1": "공지사항",
                 "2": "갤러리",
                 "3": "포토 슬라이더",
                 "4": "게시판"
               };

               return typeMap[value] || "알 수 없음";
          }
        },

        { title: "게시판 이름", field: "bbs_name", hozAlign: "left" },
        {
            title: "게시판 수정",
            headerSort: false,
            headerHozAlign: "center",
            formatter: () => "<button class='btnMove'>📝수정</button>",
            width: 100,
            hozAlign: "center",
            cellClick: function (e, cell) {
              const rowData = cell.getRow().getData();

              console.log(rowData);

              Swal.fire({
                title: `게시판 수정`,
                html: `
                  <div style="text-align: left; font-size: 14px;">
                    <div style="margin-bottom: 12px;">
                      <label style="display:block; margin-bottom:4px;">📂 게시판 유형</label>
                      <select id="swalBbsType" class="swal2-input" style="width: 100%;">
                        <option value="1" ${rowData.bbs_type == 1 ? 'selected' : ''}>공지사항</option>
                        <option value="2" ${rowData.bbs_type == 2 ? 'selected' : ''}>갤러리</option>
                        <option value="3" ${rowData.bbs_type == 3 ? 'selected' : ''}>포토 슬라이더</option>
                        <option value="4" ${rowData.bbs_type == 4 ? 'selected' : ''}>게시판</option>
                      </select>
                    </div>

                    <div>
                      <label style="display:block; margin-bottom:4px;">📝 게시판 이름</label>
                      <input id="swalBbsName" class="swal2-input" value="${rowData.bbs_name}" style="width: 85%;" />
                      <input type="hidden" id="swalBbs_id" class="swal2-input"style="width: 85%;" />
                    </div>
                  </div>
                `,
                showCancelButton: true,
                confirmButtonText: '저장',
                cancelButtonText: '취소',
                didOpen: () => {
                    // 💡 여기서 DOM에 접근 가능
                    document.getElementById('swalBbsType').value = rowData.bbs_type;
                    document.getElementById('swalBbsName').value = rowData.bbs_name;
                    document.getElementById('swalBbs_id').value = rowData.bbs_id;
                },
                preConfirm: () => {
                  return {
                    bbs_type: document.getElementById('swalBbsType').value,
                    bbs_name: document.getElementById('swalBbsName').value,
                    bbs_id: document.getElementById('swalBbs_id').value
                  }
                }
              }).then((result) => {
                if (result.isConfirmed) {
                  bbsUpdate(result.value);
                }
              });
            }

        },
        {
          title: "게시판 이동",
          formatter: () => "<button class='btnMove'>🔗 이동</button>",
          width: 100,
          headerHozAlign: "center",
          hozAlign: "center",
          headerSort: false,
          cellClick: function (e, cell) {
            const rowData = cell.getRow().getData();
            const {bbs_id} = rowData;
            window.location.href = '/cms/bbs/' + bbs_id;
          }
        },
         {
            title: "컨텐츠 관리",
            formatter: () => "<button class='btnMove'>⚙️ 관리</button>",
            width: 100,
            headerHozAlign: "center",
            hozAlign: "center",
            headerSort: false,
            cellClick: function (e, cell) {
            const rowData = cell.getRow().getData();
                const {bbs_id} = rowData;
                window.location.href = '/cms/bbsAdmin/' + bbs_id;
             }
         }
      ]
    });


});

function bbsAdd() {
  Swal.fire({
    title: `게시판 등록`,
    html: `
      <div style="text-align: left; font-size: 14px;">
        <div style="margin-bottom: 12px;">
          <label style="display:block; margin-bottom:4px;">📂 게시판 유형</label>
          <select id="swalBbsType" class="swal2-input" style="width: 100%;">
            <option value="1" selected>공지사항</option>
            <option value="2">갤러리</option>
            <option value="3">포토 슬라이더</option>
            <option value="4">게시판</option>
          </select>
        </div>

        <div>
          <label style="display:block; margin-bottom:4px;">📝 게시판 이름</label>
          <input id="swalBbsName" class="swal2-input" value="" style="width: 85%;" />
        </div>
      </div>
    `,
    showCancelButton: true,
    confirmButtonText: '저장',
    cancelButtonText: '취소',
    preConfirm: () => {
      return {
        bbs_type: document.getElementById('swalBbsType').value,
        bbs_name: document.getElementById('swalBbsName').value
      };
    }
  }).then((result) => {
    if (result.isConfirmed) {
      bbsInsert(result.value);
    }
  });
}



function bbsDel(){

 const selectedRows = boardTable.getSelectedData();

  if (selectedRows.length === 0) {
    Swal.fire('삭제할 항목을 선택해주세요.');
    return;
  }

   Swal.fire({
      title: "정말 삭제하시겠습니까?",
      text: `총 ${selectedRows.length}개 항목이 삭제됩니다.`,
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: "삭제",
      cancelButtonText: "취소"
    }).then((result) => {
      if (result.isConfirmed) {
        const bbsIdList = selectedRows.map(row => row.bbs_id).join(",");

        console.log("삭제할 bbs_id_list:", bbsIdList);

        $.ajax({
                    url: '/cms/api/bbsDelete',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        bbs_id_list : bbsIdList
                    }),
                    success: function (res) {
                       const { success = false } = res;
                       if(success){
                         Swal.fire('✅ 삭제 완료', '삭제되었습니다.', 'success');
                         boardTable.setData();
                       }else{
                        Swal.fire('삭제에 실패하였습니다.')
                       }
                    }
            });

      }
   });

}


function bbsInsert(bbs_data){
    $.ajax({
            url: '/cms/api/bbsInsert',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(bbs_data),
            success: function (res) {
               const { success = false } = res;
               if(success){
                 Swal.fire('✅ 등록 완료', '변경사항이 반영되었습니다.', 'success');
                 boardTable.setData();
               }else{
                Swal.fire('저장에 실패하였습니다.')
               }
            }
    });
}

function bbsUpdate(bbs_data){
      $.ajax({
        url: '/cms/api/bbsUpdate',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(bbs_data),
        success: function (res) {
           const { success = false } = res;
           if(success){
             Swal.fire('✅ 수정 완료', '변경사항이 반영되었습니다.', 'success');
             boardTable.setData();
           }else{
            Swal.fire('저장에 실패하였습니다.')
           }
        }
      });

}


</script>





</body>