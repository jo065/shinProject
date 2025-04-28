let adminTable = null;
let bbs_id = null;
let bbs_type = null;
let cateMap = {};

$(document).ready(function () {
  bbs_id = $("#bbs_id").val();
  bbs_type = $("#bbs_type").val();

  let bbs_info = loadBBSInfo(bbs_id);
  console.log(bbs_info);

  let labelMap = {
     "1" : "공지사항",
     "2" : "갤러리",
     "3" : "포토 슬라이더",
     "4" : "게시판"
  }


  $("#container h4").append(` >  ${bbs_info.bbs_name} (게시판 유형 : ${labelMap[bbs_type]})`);

    $.ajax({
        url: '/cms/api/getCateList/' + bbs_id,
        method: 'GET',
        contentType: 'application/json',
        success: function(res) {
          const { data = [] } = res;
          console.log('cateListup', data);

          for(let item of data){
            cateMap[item.cat_id] = item.cat_label;
          }

          tabulatorInit();

        },
        error: function(xhr, status, error) {
          console.error('❌ 카테고리 리스트 가져오기 실패:', error);
        }
      });




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

function tabulatorInit(){


  // 테이블 초기화
    adminTable = new Tabulator("#contentTable", {
      layout: "fitColumns",
      height: 500,
      placeholder: "등록된 콘텐츠가 없습니다.",
      selectable: true,
      ajaxURL: `/cms/bbs/getContentsList/${bbs_id}`,
      ajaxConfig: "GET",
      ajaxResponse: function (url, params, response) {
        return response.data;  // ✅ response에서 data만 추출
      },
      columns: [
        {
            title: "",
            formatter: "rowSelection",
            titleFormatter: "rowSelection",
            hozAlign: "center",
            headerHozAlign: "center",
            width: 50,
            headerSort: false
        },
        {
            title: "카테고리", field: "cat_id", hozAlign: "left", width: 150,
            formatter: function(cell){
                const value = cell.getValue();

                const label = cateMap[value] || '카테고리 없음';

                return label;
            }
        },
        { title: "제목", field: "title", hozAlign: "left", widthGrow: 2 },
        {
                   title: "작성일",
                   field: "reg_dt",
                   width: 200,
                   formatter: function(cell) {
                     const value = cell.getValue();
                     const date = new Date(value);

                     // YYYY-MM-DD HH:mm:ss 형식으로 포매팅
                     const yyyy = date.getFullYear();
                     const MM = String(date.getMonth() + 1).padStart(2, '0');
                     const dd = String(date.getDate()).padStart(2, '0');
                     const hh = String(date.getHours()).padStart(2, '0');
                     const mm = String(date.getMinutes()).padStart(2, '0');
                     const ss = String(date.getSeconds()).padStart(2, '0');

                     return `${yyyy}-${MM}-${dd} ${hh}:${mm}:${ss}`;
                   }
        },
        {
          title: "파일명",
          field: "file_path",
          formatter: function (cell) {
            const value = cell.getValue();
            return value ? value : "-";
          }
        },
        {
          title: "미리보기",
          formatter: () => `<button class="btnPreview">🔍 보기</button>`,
          cellClick: function (e, cell) {
              const data = cell.getRow().getData();

              if(bbs_type == 1 || bbs_type == 4){
                moveBBSContent(data);
                return;
              }

              const imageTag = data.file_id
                ? `<img src="/cms/cdn/img/${data.file_id}" alt="첨부 이미지" style="width:100%; max-width:400px; margin-top:12px; border-radius:6px;">`
                : "";

              Swal.fire({
                title: data.title || "제목 없음",
                html: `
                  <div style="text-align:center;">
                    <div style="margin-bottom:10px; font-size:14px;">
                      <div style="padding: 6px 0;"> 본문 : ${data.contents || "(내용 없음)"}</div>
                    </div>
                    ${imageTag}
                  </div>
                `,
                width: 600,
                showCloseButton: true,
                confirmButtonText: '닫기'
              });
            },
          hozAlign: "center",
          width: 100
        },
        {
          title: "수정",
          formatter: () => `<button class="btnEdit">수정</button>`,
          width: 100,
          hozAlign: "center",
          cellClick: function (e, cell) {
            const rowData = cell.getRow().getData();
            editContent(rowData);

          }
        }
      ]
    });

}

function moveBBSContent(data = {}) {
    const { content_id } = data;

    if (content_id) {
        window.location.href = `/cms/bbs/viewContent/${content_id}`;
    } else {
        console.warn('⚠️ content_id가 없습니다.');
    }
}


function insertContent() {

    let _bbs_type = Number.parseInt(bbs_type);

    switch(_bbs_type){
        case 1:
            bbsContentInsert();
            break;
        case 2:
            imageContentInsert();
            break;
        case 3:
            imageContentInsert();
            break;
        case 4:
            bbsContentInsert();
            break;
    }

}

function bbsContentInsert(){
    window.location.href = `/cms/admin?menu=editor&bbs_id=${bbs_id}`;
}

function imageContentInsert(){
    Swal.fire({
        title: '콘텐츠 등록',
        html: `
          <table style="width:100%; text-align:left; font-size:14px;">
            <tr>
              <td style="width:80px; text-align: center; background: #333333; color: white; border-radius: 3px;">제목</td>
              <td><input type="text" id="swalTitle" class="swal2-input" style="width:100%; margin: 0;" /></td>
            </tr>
            <tr>
                <td style="width:80px; text-align: center; background: #333333; color: white; border-radius: 3px;">카테고리</td>
                <td>
                    <select id="swalCate" class="swal2-input" style="width:100%; margin:0;">
                        <option value="">선택하세요</option>
                    </select>
                </td>
            </tr>
            <tr>
              <td style="text-align: center; background: #333333; color: white; border-radius: 3px;">본문</td>
              <td><textarea id="swalContents" class="swal2-textarea" style="width:100%; margin: 0; height:80px;"></textarea></td>
            </tr>
            <tr>
              <td style="text-align: center; background: #333333; color: white; border-radius: 3px;">이미지</td>
              <td>
                <input type="file" id="fileUpload" />
              </td>
            </tr>
          </table>
        `,
        didOpen: () => {


           // 카테고리 init
           initCate("#swalCate");



          FilePond.registerPlugin(FilePondPluginImagePreview);

          FilePond.create(document.getElementById('fileUpload'), {
            allowMultiple: false,
            allowImagePreview: true,
            server: {
              process: {
                url: '/cms/api/uploadImage',
                method: 'POST',
                ondata: (formData) => {
                  formData.append('mode', 1); // 등록
                  return formData;
                },
                onload: (res) => {
                  const { file_id } = JSON.parse(res);
                  document.getElementById('fileUpload').setAttribute('data-uploaded-file-id', file_id);
                  return file_id;
                }
              },
              revert: '/cms/api/deleteTempImage'
            }
          });
        },
        showCancelButton: true,
        confirmButtonText: '등록',
        cancelButtonText: '취소',
        preConfirm: () => {
          return {
            bbs_id: document.getElementById('bbs_id').value, // 게시판 ID는 숨겨진 input에서 가져옴
            title: document.getElementById('swalTitle').value,
            cat_id : document.getElementById('swalCate').value,
            contents: document.getElementById('swalContents').value,
            file_id: document.getElementById('fileUpload').getAttribute('data-uploaded-file-id') || null
          };
        }
      }).then(result => {
        if (result.isConfirmed) {
          $.ajax({
            url: '/cms/api/insertContent',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(result.value),
            success: function (res) {
              if (res.success) {
                Swal.fire('✅ 등록 완료', '', 'success');
                adminTable.setData(); // 목록 새로고침
              } else {
                Swal.fire('⚠️ 등록 실패', '잠시 후 다시 시도해주세요.', 'error');
              }
            }
          });
        }
    });
}

function initCate(selector = "#swalCate") {
  $.ajax({
    url: '/cms/api/getCateList/' + bbs_id,
    method: 'GET',
    contentType: 'application/json',
    success: function(res) {
      const { data = [] } = res;
      console.log(data);

      const $select = $(selector);

      if ($select.length === 0) {
        console.error('❌ 셀렉터를 찾을 수 없습니다:', selector);
        return;
      }

      $select.empty(); // 기존 옵션 모두 제거

      // 기본 옵션 추가
      $select.append(`<option value="-1">카테고리 없음</option>`);

      // 데이터로 옵션 추가
      data.forEach(item => {
        $select.append(`<option value="${item.cat_id}">${item.cat_label}</option>`);
      });
    },
    error: function(xhr, status, error) {
      console.error('❌ 카테고리 리스트 가져오기 실패:', error);
    }
  });
}




function editContent(rowData){

    let _bbs_type = Number.parseInt(bbs_type);

    switch(_bbs_type){
        case 1:
            editBBSContent(rowData);
            break;
        case 2:
            editImageContent(rowData);
            break;
        case 3:
            editImageContent(rowData);
            break;
        case 4:
            editBBSContent(rowData);
            break;
    }
}

function editBBSContent(rowData) {

    const { content_id = null } = rowData;
    if (!content_id) {
        Swal.fire({
            icon: 'error',
            title: '오류 발생',
            text: '콘텐츠 ID를 확인할 수 없습니다.',
            confirmButtonText: '확인'
        });
        return;
    }

    window.location.href = `/cms/admin?menu=editor&bbs_id=${bbs_id}&content_id=${content_id}`;
}



function editImageContent(rowData) {
  Swal.fire({
    title: '콘텐츠 수정',
    html: `
      <table style="width:100%; text-align:center; font-size:14px;">
        <tr>
          <td style="width:80px; text-align: center; background: #333333; color: white; border-radius: 3px;">제목</td>
          <td><input type="text" id="swalTitle" class="swal2-input" style="width:100%; margin: 0;" value="${rowData.title || ''}" /></td>
        </tr>
        <tr>
            <td style="width:80px; text-align: center; background: #333333; color: white; border-radius: 3px;">카테고리</td>
            <td>
                <select id="swalCate" class="swal2-input" style="width:100%; margin:0;"></select>
            </td>
        </tr>
        <tr>
          <td style="text-align: center; background: #333333; color: white; border-radius: 3px;">본문</td>
          <td><textarea id="swalContents" class="swal2-textarea" style="width:100%; margin: 0; height:80px;">${rowData.contents || ''}</textarea></td>
        </tr>
        <tr>
          <td style="text-align: center; background: #333333; color: white; border-radius: 3px;">이미지</td>
          <td><input type="file" id="fileUpload" /></td>
        </tr>
      </table>
    `,
    didOpen: () => {

      initCate('#swalCate');


      FilePond.registerPlugin(FilePondPluginImagePreview);


      const pond = FilePond.create(document.getElementById('fileUpload'), {
        files: rowData.file_id ? [
          {
            source: rowData.file_id,
            options: {
              type: 'local',
              metadata: {
                poster: `/cms/cdn/img/${rowData.file_id}?thumb=true`
              },
              file: {
                name: rowData.original_name || 'image.jpg',
                size: rowData.file_size || 123456,
                type: 'image/jpeg',
              },
            }
          }
        ] : [],
        allowMultiple: false,
        allowRevert: true,
        allowRemove: true,
        server: {
          process: {
            url: '/cms/api/uploadImage',
            method: 'POST',
            ondata: (formData) => {
              formData.append('mode', 1);
              formData.append('file_id', rowData.file_id);
              return formData;
            },
            onload: (res) => {
              const { file_id } = JSON.parse(res);
              document.getElementById('fileUpload').setAttribute('data-new-file-id', file_id);
              return file_id;
            }
          },
          revert: (fileId, load, error) => {
            const newFileId = document.getElementById('fileUpload').getAttribute('data-new-file-id');
            if (newFileId) {
              fetch(`/cms/api/deleteTempImage?file_id=${newFileId}`, { method: 'DELETE' })
                .then(() => {
                  document.getElementById('fileUpload').removeAttribute('data-new-file-id');
                  load();
                })
                .catch(error);
            } else {
              load(); // 아무것도 안 한 경우 그냥 닫기
            }
          }
        }
      });
    },
    showCancelButton: true,
    confirmButtonText: '수정',
    cancelButtonText: '취소',
    preConfirm: () => {
      return {
        content_id: rowData.content_id,
        title: document.getElementById('swalTitle').value,
        contents: document.getElementById('swalContents').value,
        cat_id : document.getElementById('swalCate').value,
        file_id: rowData.file_id || null,
        new_file_id: document.getElementById('fileUpload').getAttribute('data-new-file-id') || null
      };
    }
  }).then((result) => {
    if (result.isConfirmed) {
      const data = result.value;

      // 수정 요청 보내기
      $.ajax({
        url: '/cms/api/updateContent',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function (res) {
          if (res.success) {
            Swal.fire('✅ 수정 완료', '변경사항이 반영되었습니다.', 'success');
            adminTable.setData();
          } else {
            Swal.fire('❌ 수정 실패', '저장 중 오류가 발생했습니다.');
          }
        }
      });
    }
  });
}




function deleteContents() {
    const selectedRows = adminTable.getSelectedData();

    if (selectedRows.length === 0) {
        Swal.fire('⚠️ 삭제할 항목을 선택해주세요.');
        return;
    }

    const contentIdList = selectedRows.map(row => row.content_id).join(',');

    Swal.fire({
        title: '정말 삭제하시겠습니까?',
        text: '삭제된 데이터는 복구할 수 없습니다.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: '삭제',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/cms/api/deleteContents',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ contentIdList: contentIdList }),
                success: function (res) {
                    if (res.success) {
                        Swal.fire('✅ 삭제 완료', '변경사항이 반영되었습니다.', 'success');
                        adminTable.setData(); // 데이터 새로고침
                    } else {
                        Swal.fire('❌ 삭제 실패', '저장 중 오류가 발생했습니다.', 'error');
                    }
                },
                error: function () {
                    Swal.fire('❌ 서버 오류', '잠시 후 다시 시도해주세요.', 'error');
                }
            });
        }
    });
}


function manageCate(bbs_id){

    Swal.fire({
      title: '📁 카테고리 관리',
      width: 700,
      html: `
        <div style="margin-bottom: 10px; display: flex; align-items: center;">
          <input id="newCategoryName" class="" placeholder="새 카테고리 이름" style="width: calc(100% - 120px);display: inline-block;height: 50px;">
          <button id="addCategoryBtn" class="swal2-confirm swal2-styled" style="width: 120px; height: 50px; margin-left: 10px;">➕ 추가</button>
        </div>
        <div id="categoryTable" style="height: 300px;"></div>
      `,
      showCancelButton: true,
      confirmButtonText: '저장',
      cancelButtonText: '취소',
      didOpen: () => {
         $('#categoryTable').attr("bbsId", bbs_id);

        // Tabulator 초기화
        const table = new Tabulator("#categoryTable", {
          layout: "fitColumns",
          placeholder: "등록된 카테고리가 없습니다.",
          columns: [
            { title: "cat_id", field: "cat_id", visible: false },
            { title: "bbs_id", field: "bbs_id", visible: false },
            { title: "카테고리명", field: "cat_label", editor: "input" },
            {
              title: "삭제",
              width: 80,
              hozAlign: "center",
              formatter: function() {
                return `
                  <button style="border:none;">
                    ❌
                  </button>
                `;
              },
              cellClick: function (e, cell) {
                cell.getRow().delete();
              }
            }

          ],
          data: [] // 초기 데이터는 비어있음
        });

        table.on('tableBuilt', () => {
            console.log('tb', bbs_id);


             $.ajax({
                url: '/cms/api/getCateList/'+bbs_id,
                method: 'GET',
                contentType: 'application/json',
                success: function(res) {

                    const {data=[]} = res;
                    table.setData(data);
                    setTimeout(() => {
                        table.redraw();
                    },200);

                },
                error: function(xhr, status, error) {
                  console.error('❌ 카테고리 리스트 가져오기 실패:', error);
                  Swal.fire({
                    icon: 'error',
                    title: '불러오기 실패',
                    text: '카테고리 목록을 불러오는데 실패했습니다.'
                  });
                }
              });


        });

        // 추가 버튼 이벤트
        document.getElementById('addCategoryBtn').addEventListener('click', () => {
          const input = document.getElementById('newCategoryName');
          const name = input.value.trim();
          if (name === '') {
            Swal.showValidationMessage('카테고리명을 입력해주세요!');
            return;
          }

          // Tabulator에 추가
          table.addRow({ cat_label: name, bbs_id:bbs_id, cat_id:-1 });
          input.value = ''; // 입력창 비우기
        });

        // 저장용 글로벌 연결
        Swal.tabulatorInstance = table;
      },
      preConfirm: () => {
        // 저장 버튼 누르면 현재 테이블 데이터 가져오기
        return Swal.tabulatorInstance.getData();
      }
    }).then((result) => {
      if (result.isConfirmed) {
        console.log('✅ 최종 저장할 카테고리 리스트:', result.value);
        saveCategories(bbs_id, result.value); // 저장 로직 호출
      }
    });
}

function saveCategories(bbs_id, data) {
  console.log("✅ saveCategories 호출됨:", bbs_id, data);

  const payload = {
    cateList: JSON.stringify(data) // ⭐ data를 통째로 문자열화
  };

  $.ajax({
    url: '/cms/api/saveCateList/' + bbs_id,
    method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(payload),
    success: function(res) {
      console.log('✅ 저장 성공:', res);

      Swal.fire({
        icon: 'success',
        title: '저장 완료',
        text: '카테고리 목록이 저장되었습니다!',
        timer: 1500,
        showConfirmButton: false
      });
    },
    error: function(xhr, status, error) {
      console.error('❌ 저장 실패:', error);

      Swal.fire({
        icon: 'error',
        title: '저장 실패',
        text: '잠시 후 다시 시도해주세요.'
      });
    }
  });
}
