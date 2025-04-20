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

        const tree = this._buildTree(flatList);
        console.log('loaded_menu', flatList, tree);
        const dom = this._renderTree(tree);
        this.container.innerHTML = '';
        this.container.appendChild(dom);
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

      const a = document.createElement('a');
      let href = node.page_path || '#';

        // 조건: 게시판 페이지이면서, page_path가 "/cms/bbs"로 시작하고, bbs_id가 존재할 때
        if (
          String(node.page_type) === "1" &&
          href.startsWith("/cms/bbs") &&
          node.bbs_id != null &&
          node.bbs_id !== -1
        ) {
          href = `/cms/bbs/${node.bbs_id}`;
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