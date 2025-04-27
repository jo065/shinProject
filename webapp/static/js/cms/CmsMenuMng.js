/**
* @author : doil
*/
class CmsMenuMng {
  constructor(el, options = {}) {
    this.container = typeof el === 'string' ? document.querySelector(el) : el;
    this.maxDepth = options.maxDepth ?? -1; // -1: 무제한
    this.direction = options.direction ?? 'horizontal';  // horizontal or vertical
    this.apiUrl = '/cms/api/menuFlatList';

     this.init();
  }

  init() {
    this._loadData();
  }

 _loadData() {
   fetch(this.apiUrl)
     .then(res => res.json())
     .then(flatList => {
       console.log('--- flatList ---', flatList);

               // 1. bbs_id가 있는 항목만 찾기
               const bbsId = document.getElementById('bbs_id')?.value;

               // bbs_id가 존재할 경우에만 flatList에서 찾기
               if (bbsId) {
                 const menu = flatList.find(item => item.bbs_id && item.bbs_id === parseInt(bbsId));

                 // 2. 해당 bbs_id가 있는 경우 제목 설정
                 if (menu) {
                   document.querySelector('.section-title').textContent = menu.menu_name;
                 } else {
                   console.error("해당 bbs_id에 맞는 메뉴가 없습니다.");
                 }
               } else {
                 console.warn("bbs_id가 존재하지 않거나 잘못된 값입니다.");
               }


       const tree = this._buildTree(flatList);
       const dom = this._renderTree(tree);
       this.container.innerHTML = '';
       this.container.appendChild(dom);

       this._renderBbsButtons(flatList);  // 조각명판, 실크인쇄 버튼들

       const tabsOnly = this._renderTabs(flatList);  // 버튼만 직접 만든다

            if (tabsOnly.length > 0) {
              setTimeout(() => {
                openTab(`tab${tabsOnly[0].bbs_id}`, tabsOnly[0].bbs_id);
              }, 0);
            }
     });
 }



   _renderTabs(flatList) {
     const tabsOnly = flatList.filter(item => item.bbs_id != null);

     const tabContainer = document.getElementById('tabButtons');
     if (!tabContainer) return [];

     tabContainer.innerHTML = '';  // 기존 버튼 지우기

     tabsOnly.forEach((item, idx) => {
       const tabId = item.bbs_id ? `tab${item.bbs_id}` : `tab${idx}`;  // bbs_id 기준
       const button = document.createElement('button');
       button.className = 'tab-btn';
       button.textContent = item.menu_name || `메뉴${idx + 1}`;
       button.setAttribute('data-tab', tabId);

       button.onclick = () => openTab(tabId, item.bbs_id);

       tabContainer.appendChild(button);

       console.log('버튼 생성:', button.textContent, '=>', tabId);  // 디버깅용
     });

     return tabsOnly; // 첫 번째 탭 자동 오픈을 위해 리턴
   }





  _renderBbsButtons(flatList) {
      const buttonBox = document.querySelector('.about-image .button-box');
      if (!buttonBox) return; // 버튼 박스가 없는 페이지에서는 무시

      buttonBox.innerHTML = ''; // 기존 버튼 지우기

      flatList
        .filter(item => item.bbs_id != null) // bbs_id가 있는 데이터만
        .forEach(item => {
            const a = document.createElement('a');
            a.href = `${item.page_path}/${item.bbs_id}`; // ex) /cms/bbs/1
            a.className = 'plate-button';
            a.innerHTML = `<i class="fa-regular fa-share-from-square"></i> ${item.menu_name}`;
            buttonBox.appendChild(a);
        });
  }

  _buildTree(flatList) {
    const idMap = {};
    const tree = [];

    flatList.forEach(item => {
      idMap[item.tree_id] = { ...item, children: item.children ?? [] };
    });

    flatList.forEach(item => {
      const node = idMap[item.tree_id];
      if (item.parent_id && idMap[item.parent_id]) {
        idMap[item.parent_id].children.push(node);
      } else {
        tree.push(node);
      }
    });

    return tree;
  }

  _renderTree(treeList, depth = 1) {
    const ul = document.createElement('ul');
    ul.className = (depth === 1) ? `cms-menu-${this.direction}` : `cms-menu-vertical`;
    ul.setAttribute('data-depth', depth);

    for (const node of treeList) {
      const li = document.createElement('li');
      li.setAttribute('data-tree-id', node.tree_id);
      li.setAttribute('data-page-type', node.page_type);
      li.setAttribute('data-page-path', node.page_path || '');
      li.setAttribute('data-bbs-id', node.bbs_id ?? -1);

      let pagePath = node.page_path || '#';
      let href = '';


      const a = document.createElement('a');

      if(
        String(node.page_type) === "1" &&
        pagePath.startsWith("/cms/bbs") &&
        node.bbs_id != null &&
        node.bbs_id !== -1
      ) {
          // 게시판 링크인 경우
           href = `/cms/bbs/${node.bbs_id}`;
      } else {
          // 그 외에는 menuAccess 경유
          href = `/cms/menuAccess/${node.tree_id}`;
      }


       a.href = href;


      a.textContent = node.menu_name;
      li.appendChild(a);

      const allowRenderChildren = this.maxDepth === -1 || depth < this.maxDepth;

      if (node.children && node.children.length > 0 && allowRenderChildren) {
        const childUl = this._renderTree(node.children, depth + 1);

        // ⭐️ horizontal 1depth 아래는 submenu-wrapper로 감쌈
        if (depth === 1) {
          const wrapper = document.createElement('div');
          wrapper.className = 'submenu-wrapper';
          wrapper.appendChild(childUl);
          li.appendChild(wrapper);
        } else {
          li.appendChild(childUl); // vertical일 경우 그대로
        }
      }

      ul.appendChild(li);
    }

    return ul;
  }
}