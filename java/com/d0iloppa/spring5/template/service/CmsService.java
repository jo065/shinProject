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

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

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


		treeData = treeData.stream()
				.filter(node -> !node.get("id").equals("root"))
				.collect(Collectors.toList());

		List<Map<String, Object>> preTree = getMenuTree().stream()
				.filter(node -> !node.get("id").equals("root"))
				.collect(Collectors.toList());

		Set<Long> preTreeIds = preTree.stream()
				.map(node -> node.get("id"))
				.filter(Objects::nonNull)
				.map(val -> (val instanceof Number) ? ((Number) val).longValue() : Long.parseLong(val.toString()))
				.collect(Collectors.toSet());

		// insert 대상 (isNew : true)
		List<Map<String, Object>> insertList = treeData.stream()
				.filter(node -> Boolean.TRUE.equals(node.get("isNew")))
				.map(node -> {

					Object parentObj = node.get("parent");

					if ("root".equals(String.valueOf(parentObj))) {
						node.put("parent", null); // 명시적으로 null

					} else if (parentObj != null && parentObj instanceof String) {

						try{
							Long parent_id = Long.parseLong((String) parentObj);
							node.put("parent", parent_id); // Long으로 변환
						}catch(Exception e){

						}

					}
					return node;
				})
				.collect(Collectors.toList());


		if(insertList.size()>0)  cmsDAO.insertMenu(insertList);

		// update 대상
		List<Map<String, Object>> updateList = treeData.stream()
				.filter(node -> !Boolean.TRUE.equals(node.get("isNew")))
				.map(node -> {

					Object parentObj = node.get("parent");


					if ("root".equals(String.valueOf(parentObj))) {
						node.put("parent", null); // 명시적으로 null

					} else if (parentObj != null && parentObj instanceof String) {

						node.put("parent", Long.parseLong((String) parentObj)); // Long으로 변환
					}


					Object idObj = node.get("id");
					// id → tree_id 변환 처리
					if (idObj instanceof String) {
						try {
							Long treeId = Long.parseLong((String) idObj);
							node.put("tree_id", treeId);
						} catch (NumberFormatException e) {
							// "root" 같은 경우는 skip
						}
					}




					return node;
				})
				.collect(Collectors.toList());

		if(updateList.size()>0)  cmsDAO.updateMenu(updateList);
		
		// delete 대상
		Set<Long> newTreeIds = treeData.stream()
				.map(node -> node.get("tree_id"))
				.filter(Objects::nonNull)
				.map(val -> (val instanceof Number) ? ((Number) val).longValue() : Long.parseLong(val.toString()))
				.collect(Collectors.toSet());

		preTreeIds.removeAll(newTreeIds);
		List<Long> deleteList = new ArrayList<>(preTreeIds);


		if(deleteList.size()>0)  cmsDAO.deleteMenu(deleteList);



	}

	public List<MenuVO> getMenuList() {

		List<MenuVO> list = cmsDAO.selectList("CmsMapper.getMenuTree");

		// (1) 모든 항목을 Map으로 index화
		Map<Long, MenuVO> map = list.stream()
				.collect(Collectors.toMap(MenuVO::getTree_id, Function.identity()));

		// (2) 루트 목록 생성
		List<MenuVO> rootList = new ArrayList<>();

		// (3) 트리 구조 구성
		for (MenuVO node : list) {
			if (node.getParent_id() == null) {
				rootList.add(node); // 최상위 루트
			} else {
				MenuVO parent = map.get(node.getParent_id());
				if (parent != null) {
					parent.getChildren().add(node);
				}
			}
		}

		return rootList;


	}

	public List<Map<String, Object>> getBoardList() {

		return cmsDAO.selectList("CmsMapper.getBoardList");
	}

	public int bbsInsert(Map<String, Object> data) {

		Object bbsTypeObj = data.get("bbs_type");
		if (bbsTypeObj instanceof String) {
			data.put("bbs_type", Integer.parseInt((String) bbsTypeObj));
		} else if (bbsTypeObj instanceof Number) {
			data.put("bbs_type", ((Number) bbsTypeObj).intValue());
		}

		return cmsDAO.update("CmsMapper.bbsInsert", data);
	}

	public int bbsUpdate(Map<String, Object> data) {

		Object bbsIdObj = data.get("bbs_id");
		if (bbsIdObj instanceof String) {
			data.put("bbs_id", Long.parseLong((String) bbsIdObj));
		} else if (bbsIdObj instanceof Number) {
			data.put("bbs_id", ((Number) bbsIdObj).longValue());
		}

		// 💡 bbs_type을 Integer로 캐스팅
		Object bbsTypeObj = data.get("bbs_type");
		if (bbsTypeObj instanceof String) {
			data.put("bbs_type", Integer.parseInt((String) bbsTypeObj));
		} else if (bbsTypeObj instanceof Number) {
			data.put("bbs_type", ((Number) bbsTypeObj).intValue());
		}

		return cmsDAO.update("CmsMapper.bbsUpdate", data);
	}

	public int bbsDelete(Map<String, Object> data) {
		return cmsDAO.update("CmsMapper.bbsDelete", data);
	}

	public Map<String, Object> getBbsInfo(Long bbsId) {
		return cmsDAO.selectOne("CmsMapper.getBbsInfo", bbsId);
	}
}
