/**
 * 
 */
package com.d0iloppa.spring5.template.service;


import com.d0iloppa.spring5.template.dao.CmsDAO;
import com.d0iloppa.spring5.template.dao.HomeDAO;
import com.d0iloppa.spring5.template.model.AdminVO;
import com.d0iloppa.spring5.template.model.HomeVO;
import com.d0iloppa.spring5.template.model.MenuVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CmsService {
	
	@Autowired
    private CmsDAO cmsDAO;

	public AdminVO login(AdminVO vo) {

		AdminVO login = cmsDAO.selectOne("CmsMapper.login", vo);


		return login;
	}

	public List<Map<String, Object>> getMenuTree() {

		List<MenuVO> list = cmsDAO.selectList("CmsMapper.getMenuTree");

		List<Map<String, Object>> tree = new ArrayList<>();

		// ROOT 노드 추가
		Map<String, Object> root = new HashMap<>();
		root.put("id", "root");
		root.put("parent", "#");
		root.put("text", "🏠 HOME PAGE");
		tree.add(root);

		for (MenuVO vo : list) {
			Map<String, Object> node = new HashMap<>();
			node.put("id", vo.getTree_id());
			node.put("parent", vo.getParent_id() == null ? "root" : vo.getParent_id());
			node.put("text", vo.getMenu_name());
			node.put("page_type", vo.getPage_type());
			node.put("page_path", vo.getPage_path());
			node.put("bbs_id", vo.getBbs_id());
			tree.add(node);
		}

		return tree;
	}

	public void saveMenuTree(List<Map<String, Object>> treeData) {
	}
}
