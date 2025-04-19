<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/themes/default/style.min.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/jstree.min.js"></script>

<h4>메뉴 관리</h4>

<div id="container" style="display: flex; gap: 20px;">
  <!-- 좌측: 트리 구조 -->
  <div style="width: 50%;">
    <div style="margin-bottom: 10px;">
      <button id="btnAdd">+</button>
      <button id="btnDelete">−</button>
      <button id="btnApply">적용</button>
    </div>
    <div id="menuTree"></div>
  </div>

  <!-- 우측: 상세 설정 -->
  <div style="width: 50%; border: 1px solid #ccc; padding: 15px; border-radius: 5px;">
    <h4>선택된 메뉴 정보</h4>

    <div style="margin-bottom: 10px;">
      <label>메뉴명</label><br/>
      <input type="text" id="menuName" style="width: 100%;" />
    </div>

    <div style="margin-bottom: 10px;">
      <label>페이지 타입</label><br/>
      <select id="pageType" style="width: 100%;">
        <option value="1">게시판 페이지</option>
        <option value="2">정적 페이지</option>
      </select>
    </div>

    <div style="margin-bottom: 10px;">
      <label>게시판 선택</label><br/>
      <select id="bbsSelect" style="width: 100%;">
        <option value="">- 선택 -</option>
      </select>
    </div>

    <div style="margin-bottom: 10px;">
      <label>페이지 경로</label><br/>
      <input type="text" id="pagePath" value="" style="width: 100%;" />
    </div>

    <button id="btnLocalSave">저장</button>
  </div>


</div>



<script>


let currentNodeId = null;



$(function () {

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


// 선택
$('#menuTree').on('select_node.jstree', function (e, data) {
  const node = data.node;

  // 루트는 선택 자체 막기
  if (node.id === "root") {
    $('#menuTree').jstree(true).deselect_node(node);
    return;
  }

  currentNodeId = node.id;

  // 선택된 노드 정보 오른쪽에 표시
  $('#menuName').val(node.text);
  $('#pageType').val(node.data.page_type || 1);
  $('#bbsSelect').val(node.data.bbs_id || '');
  $('#pagePath').val(node.data.page_path || '');
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

    // 반영
    tree.rename_node(node, text);
    node.data.page_type = page_type;
    node.data.bbs_id = bbs_id;
    node.data.page_path = page_path;

    if (node.data.isNew == null) {
      node.data.isNew = false;
    }
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
               page_path: '',
               isNew: true
             }
        },
        'last',
        function (node) {
          tree.edit(node);
        }
      );
    });

    // 노드 삭제
    $('#btnDelete').click(function () {
      const selected = $('#menuTree').jstree('get_selected')[0];
      if (selected === "root") {
        alert("HOME PAGE는 삭제할 수 없습니다.");
        return;
      }
      $('#menuTree').jstree('delete_node', selected);
    });

    // 적용 (서버에 현재 트리 상태 전송)
    $('#btnApply').click(function () {
      const flat = tree.get_json('#', { flat: true });
      const result = flat.map((n, index) => ({
        id: n.id,
        parent: n.parent,
        text: n.text,
        sort_order: index + 1,
        ...n.data
      }));


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





});





</script>