<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/themes/default/style.min.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/jstree.min.js"></script>


<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/cms/CmsMenuMng.js"></script>
<link href="${pageContext.request.contextPath}/static/css/cms/CmsMenu.style.css" rel="stylesheet">

<style>
/* 컨테이너 스타일 */
#container {
    display: flex;
    gap: 20px;
    background: white;
    width: 95%;
    margin-left: 37px;
    padding: 10px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    border-radius: 5px;
    justify-content: start;
}

#menuTree {
  height: 300px; /* 원하는 최대 높이 (예: 400px) */
  overflow-y: auto;
  overflow-x: hidden; /* 좌우 스크롤은 막기 (선택) */
}

/* 메뉴 컨트롤 버튼 영역 */
.menu-control {
    display: flex;
    gap: 5px;
    margin: 15px;
}

/* 추가/삭제 버튼 공통 */
#btnAdd, #btnDelete {
   height: 32px;
   width: 32px;
   display: flex;
   align-items: center;
   justify-content: center;
   background-color: #f8f9fa;
   border: 1px solid #dee2e6;
   border-radius: 4px;
   font-size: 16px;
   cursor: pointer;
   color: white;
}
#btnAdd { background-color: #007bff; }
#btnDelete { background-color: #dc3545; }

/* 적용 버튼 */
#btnApply, #btnLocalSave {
    width: auto;
    padding: 0 15px;
    font-size: 13px;
    font-weight: 500;
    background-color: #343a40;
    border: none;
    color: white;
    border-radius: 3px;
}

/* 좌측 트리 메뉴 영역 */
.left-panel {
    width: 23%;
    border: 1px solid #ebebeb;
    padding: 10px;
    border-radius: 5px;
}

/* 우측 상세 설정 영역 */
.right-panel {
    width: 100%;
    border: 1px solid #ebebeb;
    padding: 15px;
    border-radius: 5px;
}

/* 세부 항목 타이틀 */
.section-title {
    margin: 0;
    padding: 3px;
    border-bottom: 1px solid #ccc;
}

/* 입력/선택 영역 */
.input-group {
    margin: 10px 0;
}
.input-group label {
    display: block;
    margin-bottom: 5px;
}
.input-row {
  margin-top: 20px;
  display: flex;
  gap: 20px; /* 좌우 간격 */
  margin-bottom: 10px;
}

.input-row .input-group {
  flex: 1; /* 두 그룹이 동일한 너비 */
}

.input-group label {
  display: block;
  margin-bottom: 5px;
}

.input-group input,
.input-group select {
  width: 100%;
  box-sizing: border-box;
  padding: 6px 10px;
  font-size: 14px;
}

.bbs-manage-link {
  margin-left: 8px;
  font-size: 12px;
  text-decoration: none;
  color: #333;
  background: #f0f0f0;
  padding: 4px 8px;
  border-radius: 4px;
  border: 1px solid #ccc;
  display: inline-block;
}

/* 게시판 관리 링크 버튼 */
.bbs-manage-link {
    display: inline-block;
    padding: 4px 8px;
    margin-left: 8px;
    font-size: 12px;
    background-color: #f0f0f0;
    border: 1px solid #ccc;
    border-radius: 4px;
    text-decoration: none;
    color: #333;
    cursor: pointer;
}

/* 페이지 경로 안내문구 */
.path-hint {
    font-size: 12px;
    color: #888;
    margin-bottom: 3px;
    cursor: pointer;
}

/* 저장 버튼 */
#btnLocalSave{
    margin-top: 10px;
    height: 30px;
    cursor: pointer;
}

/* 트리 wholerow 기본 스타일 */
.jstree-wholerow {
   border: 1px solid #f7f7f7;
}

/* 샘플 영역 */
#sampleArea {
        margin-top: 30px;
        width: 1600px;
        text-align: center;
        margin-left: 32px;
}

/* 샘플 방향 선택 */
.direction-control {
    display: flex;
    align-items: center;
    gap: 20px;
}

/* 메뉴 프리뷰 영역 */
.menu-preview, .menu-preview-v2 {
    margin-top: 20px;
    padding: 10px;
    border: 1px solid #ddd;
}

/* 호출방법 코드 박스 */
#code {
    margin-top: 20px;
    padding: 12px 16px;
    background-color: #c8c7c7;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-family: 'Courier New', monospace;
    font-size: 13px;
    color: #333;
    white-space: pre;
}

input, select {    border: 1px solid #c3c3c3;}
</style>

<body>
<body>
<h3 style="margin-left: 40px;">메뉴 관리</h3>

<div id="container">
  <!-- 좌측: 트리 구조 -->
  <div class="left-panel">
    <div class="menu-control">
      <button id="btnAdd">+</button>
      <button id="btnDelete">−</button>
      <button id="btnApply">적용</button>
    </div>
    <div id="menuTree"></div>
  </div>

  <!-- 우측: 상세 설정 -->
  <div class="right-panel">
    <h4 class="section-title">선택된 메뉴 정보</h4>

    <!-- 메뉴명 + 페이지타입 한 줄 -->
    <div class="input-row">
      <div class="input-group">
        <label>메뉴명</label>
        <input type="text" id="menuName" />
      </div>

      <div class="input-group">
        <label>페이지 타입</label>
        <select id="pageType">
          <option value="1">게시판 페이지</option>
          <option value="2">정적 페이지</option>
        </select>
      </div>
    </div>

    <!-- 게시판 선택 + 페이지 경로 한 줄 -->
    <div class="input-row">
      <div class="input-group">
        <label>게시판 선택
          <a href="/cms/admin?menu=bbsMng" class="bbs-manage-link">⚙️ 게시판 관리</a>
        </label>
        <select id="bbsSelect">
          <option value="">- 선택 -</option>
        </select>
      </div>

      <div class="input-group">
        <label class="path-hint" onclick="applyBbsPath()" style="cursor:pointer; margin-top: 10px;">
          ※ 페이지 타입이 <strong>게시판 페이지</strong>인 경우,
          <code style="background-color: #d9d9d9; padding: 2px 6px; border-radius: 4px; font-size: 11px; font-family: monospace; color: #ed4e4e;">/cms/bbs</code>로 지정하면 이동됩니다. <strong>[클릭 시 적용]</strong>
        </label>
        <input type="text" id="pagePath" />
      </div>
    </div>

    <!-- 저장 버튼은 아래 -->
    <div style="display: flex; justify-content: center;">
    <button id="btnLocalSave">저장</button>
    </div>
  </div>
</div>

 <h3 style="margin-top: 70px;margin-left: 40px;">메뉴 구성 테스트</h3>
<div id="sampleArea">
  <div class="direction-control">
    <div>
      <label><strong>방향:</strong></label>
      <label><input type="radio" name="direction" value="horizontal" checked/> horizontal (가로) </label>
      <label><input type="radio" name="direction" value="vertical"/> vertical (세로)</label>
    </div>

    <button id="btnPreviewMenu">📋 메뉴 확인 (재로딩)</button>
  </div>

  <div id="menuPreview" class="menu-preview" style="display:none;"></div>
  <div id="menuPreview_v2" class="menu-preview-v2"></div>

</div>





<script>


let currentNodeId = null;



$(function () {



    loadingBbsList();

    $('#pageType').on('change', function () {
        const value = $(this).val();

        if (value === '1') {
          $('#bbsSelect').prop('disabled', false);  // 활성화
        } else {
          $('#bbsSelect').prop('disabled', true);   // 비활성화
        }
     });

      setTimeout(() => {
             $("#btnPreviewMenu").click();
             $('#pageType').trigger('change');
         },10);






  // jstree init
  $('#menuTree').jstree({
    'core': {
      check_callback: function (operation, node, node_parent, node_position, more) {
            // 노드 이동 제어
            if (operation === "move_node") {
              // root와 같은 depth로 옮기려는 경우
              if (node_parent.id === "#" || node_parent === "#") {
                return false; // 금지!
              }
            }

            return true; // 그 외에는 허용
       },
      'data': {
        url: '/cms/api/menuList', // ← DB에서 트리 데이터 제공
        dataType: 'json'
      }
    },
    'plugins': ['dnd', 'contextmenu', 'types', 'wholerow']
  });

  $('#menuTree').on('ready.jstree', function (e, data) {
    data.instance.open_all();

     setTimeout(() => {
           const allNodes = data.instance.get_json('#', { flat: true });

           console.log("allNodes", allNodes); // 전체 노드 구조 찍어보는 건 여전히 유용함

           if (allNodes.length > 1) { // 1번 인덱스가 존재하는지 체크
             const firstNodeId = allNodes[1].id; //1번째(두 번째 노드) 선택
             console.log("firstNodeId (1번째 인덱스)", firstNodeId);
             data.instance.select_node(firstNodeId);
           }
         }, 100);
  });


    // 선택
    $('#menuTree').on('select_node.jstree', function (e, data) {
      const node = data.node;

      // 루트는 선택 자체 막기
      if (node.id === "root") {
        $('#menuTree').jstree(true).deselect_node(node);
        return;
      }

      currentNodeId = node.id;


      // 우선순위: original → data → fallback
      const source = node.data && Object.keys(node.data).length > 0
        ? node.data
        : (node.original || {});

        // 선택된 노드 정보 오른쪽에 표시
        $('#menuName').val(node.text);
        $('#pageType').val(source.page_type || 1);
        $('#bbsSelect').val(source.bbs_id || '');
        $('#pagePath').val(source.page_path || '');

        $('#pageType').trigger('change');

    });

     // 저장
     $('#btnLocalSave').click(function () {
       if (!currentNodeId) return;

       const tree = $('#menuTree').jstree(true);
       const node = tree.get_node(currentNodeId);

       // UI 값 읽기
       const text = $('#menuName').val();
       const page_type = parseInt($('#pageType').val());
       const bbs_id = $('#bbsSelect').val() || null;
       const page_path = $('#pagePath').val();

       // data 객체 보장
       if (!node.data) node.data = {};

       // 값 반영
       node.data.page_type = page_type;
       node.data.bbs_id = bbs_id;
       node.data.page_path = page_path;

       if (node.data.isNew == null) {
         node.data.isNew = false;
       }

       tree.rename_node(node, text);

       Swal.fire('임시저장 완료. [적용] 버튼을 눌러야 최종 반영됩니다.')
     });




    // 노드 추가
    $('#btnAdd').click(function () {
      const tree = $('#menuTree').jstree(true);
      const selected = tree.get_selected()[0];

      // 선택 노드가 없거나 최상위 (#)일 경우 → root에 추가
      const parentId = (selected && selected !== "#") ? selected : "root";

     const newNode = tree.create_node(
        parentId,
        {
            text: '새 메뉴',
            data: {
               page_type: 1,
               bbs_id: null,
               page_path: '/',
               isNew: true
             }
        },
        'last',
        function (node) {
          // tree.edit(node);
          tree.deselect_all();       // 기존 선택 해제
          tree.select_node(node);    // 새 노드 선택

          setTimeout(() => {
            const $input = $("#menuName");
            $input.focus();      // 포커스 이동
            $input.select();     // 기존 텍스트 전체 선택 (또는 커서 활성화)
          }, 50);

        }
      );


    });

    // 노드 삭제
    $('#btnDelete').click(function () {
      const selected = $('#menuTree').jstree('get_selected')[0];
      if (selected === "root") {
        Swal.fire({
             icon: 'warning',
             title: '주의',
             text: '🏠 HOME PAGE는 삭제할 수 없습니다.',
           });
         return;
      }
        const node =  $('#menuTree').jstree(true).get_node(selected);
        const childrenCount = node.children_d.length;

        Swal.fire({
          title: '정말 삭제하시겠습니까?',
          html: childrenCount > 0
            ? `선택한 메뉴뿐 아니라 <strong>${childrenCount}</strong>개의 하위 메뉴도 함께 삭제됩니다.`
            : '선택한 메뉴를 삭제하시겠습니까?',
          icon: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#d33',
          confirmButtonText: '삭제',
          cancelButtonText: '취소',
        }).then((result) => {
          if (result.isConfirmed) {
             $('#menuTree').jstree(true).delete_node(selected);
            Swal.fire('삭제 완료', '메뉴가 삭제되었습니다.', 'success');
          }
        });
    });

    // 적용 (서버에 현재 트리 상태 전송)
    $('#btnApply').click(function () {

      const tree = $('#menuTree').jstree(true);
      const flat = tree.get_json('#', { flat: true });

      const result = flat.map((n, index) => {
        const _t = tree.get_node(n.id);
        const source =
          n.data && Object.keys(n.data).length > 0
            ? n.data
            : (_t.original || {});

        return {
          id: n.id,
          parent: n.parent,
          text: n.text,
          sort_order: Number(index + 1),
          page_type: Number(source.page_type ?? 1),
          bbs_id: source.bbs_id != null ? Number(source.bbs_id) : null,
          page_path: source.page_path ?? '/',
          isNew: Boolean(source.isNew ?? false)
        };
      });


      console.log(result);


      $.ajax({
        url: '/cms/api/saveMenuTree',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(result),
        success: function (res) {
           const { success = false } = res;
           if(success){
            Swal.fire('저장되었습니다!')
           }else{
            Swal.fire('저장에 실패하였습니다.')
           }
        }
      });



    });



 $('#btnPreviewMenu').click(function () {

    const direction = $('input[name="direction"]:checked').val();
    console.log(direction);

    const menu = new CmsMenuMng('#menuPreview_v2',{
      maxDepth: -1,           // 무제한
      direction: direction
    })


    const sampleCode = `
        const menu = new CmsMenuMng('#targetElement', {
          maxDepth: -1,           // -1: 무제한
          direction: 'horizontal' // 또는 'vertical'
        });
    `;

      $('#code').text(sampleCode);


      $.ajax({
        url: '/cms/api/menuFlatList',  // ← DB에서 메뉴 전체 가져오는 API (계층 X, flat 구조)
        method: 'GET',
        dataType: 'json',
        success: function (menuList) {

          const tree = buildTree(menuList);
          const $treeDom = renderMenuTree_jQuery(tree); // jQuery 버전 호출
          $('#menuPreview').empty().append($treeDom);
        }
      });
    });



});

function buildTree(flatList) {
  const idMap = {};
  const tree = [];

  // 1. 먼저 ID 기준으로 매핑
  flatList.forEach(item => {
    item.children = item.children || [];
    idMap[item.tree_id] = item;
  });

  // 2. 부모-child 연결
  flatList.forEach(item => {
    const parentId = item.parent_id;
    if (parentId && idMap[parentId]) {
      idMap[parentId].children.push(item);
    } else {
      tree.push(item); // 부모가 없으면 최상위 노드
    }
  });

  return tree;
}


function renderMenuTree_jQuery(treeList) {
  const $ul = $('<ul style="display:flex"></ul>');

  treeList.forEach(node => {
    const $li = $('<li style="margin-right: 30px;"></li>');

    const typeText = String(node.page_type ?? "2") === "1" ? "게시판" : "정적";
    const $text = $('<strong></strong>').text(node.menu_name);
    const $type = $('<span></span>').text('(' + typeText + ')').css('margin-left', '6px');  // ← 여백 추가



    $li.append($text).append($type);

    // 자식이 있으면 재귀적으로 붙임
    if (node.children && node.children.length > 0) {
      const $childTree = renderMenuTree_jQuery(node.children);
      $li.append($childTree);
    }

    $ul.append($li);
  });

  return $ul;
}


function loadingBbsList() {
  const $select = $("#bbsSelect");
  $select.empty();
  $select.append('<option value="">- 선택 -</option>');

  $.ajax({
    url: '/cms/api/boardList',
    method: 'GET',
    dataType: 'json',
    success: function (boardList) {
      boardList.forEach(function(bbs) {
        var option = '<option value="' + bbs.bbs_id + '">' + bbs.bbs_name + '</option>';
        $select.append(option);
      });
    }
  });
}


function applyBbsPath(){
    $("#pagePath").val('/cms/bbs');
}



</script>
</body>