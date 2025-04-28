/**
 * 
 */
package com.d0iloppa.spring5.template.service;


import com.d0iloppa.spring5.template.config.AppConfig;
import com.d0iloppa.spring5.template.dao.CmsDAO;
import com.d0iloppa.spring5.template.model.AdminVO;
import com.d0iloppa.spring5.template.model.MenuVO;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.lang.reflect.Type;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class CmsService {


	@Autowired
	private AppConfig appConfig;


	@Value("${cms.file.root}")
	private String cmsFILE_ROOT;

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

		return cmsDAO.insert("CmsMapper.bbsInsert", data);
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

	public List<Map<String, Object>> getContentsList(Long bbsId) {
		return cmsDAO.selectList("CmsMapper.getContentsList", bbsId);
	}

	public Map<String, Object> getFileInfo(Long fileId) {
		return cmsDAO.selectOne("CmsMapper.getFileInfo", fileId);
	}

	public MenuVO getPageInfo(Long treeId) {
		return cmsDAO.selectOne("CmsMapper.getPageInfo",treeId);
	}

	public Long saveTempFile(int mode, MultipartFile file, String lgn_id) throws IOException {
		String rootPath = cmsFILE_ROOT;
		if (rootPath == null || rootPath.trim().isEmpty()) {
			throw new RuntimeException("파일 저장 경로가 지정되지 않았습니다.");
		}

		String datePath = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
		Path saveDir = Paths.get(rootPath, datePath);

		try {
			if (!Files.exists(saveDir)) {
				Files.createDirectories(saveDir);
			}

			String originalFileName = file.getOriginalFilename();
			if (originalFileName == null || originalFileName.trim().isEmpty()) {
				throw new RuntimeException("파일명이 비어 있습니다.");
			}

			String ext = "";
			if (originalFileName.contains(".")) {
				ext = originalFileName.substring(originalFileName.lastIndexOf("."));
			}

			// ✅ 유일한 파일명으로 저장 (UUID)
			String uuid = UUID.randomUUID().toString();
			String saveFileName = uuid + ext;
			Path targetPath = saveDir.resolve(saveFileName);
			file.transferTo(targetPath.toFile());

			// ✅ DB에 저장할 정보 구성

			Map<String, Object> fileInfo = new HashMap<>();
			fileInfo.put("file_type", ext.toLowerCase().replace(".", ""));         // 예: "jpg", "png"
			fileInfo.put("file_path", "/" + datePath + "/" + saveFileName);                          // 예: "/2025/04/21/uuid.jpg"
			fileInfo.put("file_name", originalFileName);                           // 원본 파일명
			fileInfo.put("file_size", file.getSize());
			fileInfo.put("reg_id", lgn_id);

			if(mode==1){
				cmsDAO.insert("CmsMapper.insertFile", fileInfo);
			}else{
				cmsDAO.update("CmsMapper.updateFile", fileInfo);
			}



			return (Long) fileInfo.get("file_id");

		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("파일 저장 중 오류 발생", e);
		}
	}

	public void deleteTempFile(Long fileId) {
		if (fileId == null) return;

		// 1. DB에서 파일 정보 조회
		Map<String, Object> fileInfo = cmsDAO.selectOne("CmsMapper.getFileInfo", fileId);
		if (fileInfo == null) return;

		// 2. 실제 파일 경로
		String filePath = (String) fileInfo.get("file_path");
		if (filePath != null) {
			Path fullPath = Paths.get(cmsFILE_ROOT, filePath);
			try {
				Files.deleteIfExists(fullPath);  // 파일이 존재할 경우만 삭제
			} catch (IOException e) {
				e.printStackTrace(); // 삭제 실패 시 로그 출력
			}
		}

		// 3. DB 레코드 삭제
		cmsDAO.delete("CmsMapper.deleteFile", fileId);
		cmsDAO.delete("CmsMapper.deleteFile_link", fileId);
		
		
	}

	public int insertContent(Map<String, Object> data) {


		// Long으로 변환 처리
		Object bbsIdObj = data.get("bbs_id");
		if (bbsIdObj instanceof String) {
			data.put("bbs_id", Long.parseLong((String) bbsIdObj));
		} else if (bbsIdObj instanceof Number) {
			data.put("bbs_id", ((Number) bbsIdObj).longValue());
		}

		Object fileIdObj = data.get("file_id");
		if (fileIdObj instanceof String) {
			data.put("file_id", Long.parseLong((String) fileIdObj));
		} else if (fileIdObj instanceof Number) {
			data.put("file_id", ((Number) fileIdObj).longValue());
		}

		Object catIdObj = data.get("cat_id");
		if (catIdObj instanceof String) {
			data.put("cat_id", Long.parseLong((String) catIdObj));
		} else if (catIdObj instanceof Number) {
			data.put("cat_id", ((Number) catIdObj).longValue());
		}


		data.put("content_type", 3);


		int result = cmsDAO.insert("CmsMapper.insertContent", data); // content_id 자동 생성

		// 2. 첨부파일 연결 (있을 경우)
		if (fileIdObj != null && !"".equals(fileIdObj.toString())) {
			Map<String, Object> linkMap = new HashMap<>();
			linkMap.put("content_id", data.get("content_id"));  // insertContent 실행 후 content_id가 자동으로 들어감
			linkMap.put("file_id", Long.parseLong(fileIdObj.toString()));
			linkMap.put("file_order", 1);

			result = cmsDAO.insert("CmsMapper.insertFileLink", linkMap);
		}



		String appened_img = data.getOrDefault("appened_img", "").toString();

		if (!"".equals(appened_img)) {
			String[] splits = appened_img.split(",");
			int idx = 1;
			for (String img_id : splits) {
				try {
					Map<String, Object> linkMap = new HashMap<>();
					linkMap.put("content_id", data.get("content_id")); // insertContent 실행 후 content_id
					linkMap.put("file_id", Long.parseLong(img_id.trim())); // 숫자로 변환
					linkMap.put("file_order", idx++);

					result = cmsDAO.insert("CmsMapper.insertFileLink", linkMap);
				} catch (NumberFormatException e) {
					// 잘못된 데이터는 그냥 스킵하고 넘어간다
					continue;
				}
			}
		}


		return result;


	}

	public int updateContent(Map<String, Object> data) {




		// Long으로 변환 처리
		Object content_id = data.get("content_id");
		if (content_id instanceof String) {
			data.put("content_id", Long.parseLong((String) content_id));
		} else if (content_id instanceof Number) {
			data.put("content_id", ((Number) content_id).longValue());
		}

		// 기존 file_id
		Object fileIdObj = data.get("file_id");
		Long file_id = null;
		if (fileIdObj instanceof String) {
			data.put("file_id", Long.parseLong((String) fileIdObj));
			file_id = Long.parseLong((String) fileIdObj);
		} else if (fileIdObj instanceof Number) {
			data.put("file_id", ((Number) fileIdObj).longValue());
			file_id = ((Number) fileIdObj).longValue();
		}

		Object catIdObj = data.get("cat_id");
		if (catIdObj instanceof String) {
			data.put("cat_id", Long.parseLong((String) catIdObj));
		} else if (catIdObj instanceof Number) {
			data.put("cat_id", ((Number) catIdObj).longValue());
		}



		Object new_fileIdObj = data.get("new_file_id");

		data.put("content_type", 3);

		int result = cmsDAO.update("CmsMapper.updateContent",data);


		if (new_fileIdObj != null && !"".equals(new_fileIdObj.toString())) {



			bronkenLinkProcess(file_id);


			Map<String, Object> linkMap = new HashMap<>();
			linkMap.put("content_id", data.get("content_id"));  // insertContent 실행 후 content_id가 자동으로 들어감
			linkMap.put("file_id", Long.parseLong(new_fileIdObj.toString()));
			linkMap.put("file_order", 1);

			result = cmsDAO.insert("CmsMapper.insertFileLink", linkMap);
		}



		String appened_img = data.getOrDefault("appened_img", "").toString();

		if (!"".equals(appened_img)) {
			String[] splits = appened_img.split(",");
			int idx = 1;
			for (String img_id : splits) {
				try {
					Map<String, Object> linkMap = new HashMap<>();
					linkMap.put("content_id", data.get("content_id")); // insertContent 실행 후 content_id
					linkMap.put("file_id", Long.parseLong(img_id.trim())); // 숫자로 변환
					linkMap.put("file_order", idx++);

					result = cmsDAO.insert("CmsMapper.insertFileLink", linkMap);
				} catch (NumberFormatException e) {
					// 잘못된 데이터는 그냥 스킵하고 넘어간다
					continue;
				}
			}
		}


		return result;
	}

	private void bronkenLinkProcess(Long oldId) {

		if(oldId==null) return;


		Map<String, Object> fileInfo = cmsDAO.selectOne("CmsMapper.getFileInfo", oldId);
		if (fileInfo == null) return;

		// 2. 실제 파일 경로
		String filePath = (String) fileInfo.get("file_path");
		if (filePath != null) {
			Path fullPath = Paths.get(cmsFILE_ROOT, filePath);
			try {
				Files.deleteIfExists(fullPath);  // 파일이 존재할 경우만 삭제
			} catch (IOException e) {
				e.printStackTrace(); // 삭제 실패 시 로그 출력
			}
		}

		// 3. DB 레코드 삭제
		cmsDAO.delete("CmsMapper.deleteFile", oldId);
		cmsDAO.delete("CmsMapper.deleteFile_link", oldId);





	}

	public void deleteContent(Long contentId) {

		// 1. 해당 파일에 링크된 파일리스트 수집
		List<Long> linkedFileList = cmsDAO.selectList("CmsMapper.getLinkedFileIdList", contentId);

		for(Long file_id : linkedFileList){
			bronkenLinkProcess(file_id);
		}
		// 2. 컨텐츠 삭제
		cmsDAO.delete("CmsMapper.deleteContent", contentId);
	}

	public MenuVO findMenu(Long menuId) {

		List<MenuVO> menuList = getMenuList();


		MenuVO targetMenu = menuList.stream()
				.filter(menu -> Objects.equals(menu.getTree_id(), menuId))
				.findFirst()
				.orElseGet(() -> {
					MenuVO emptyMenu = new MenuVO();
					emptyMenu.setPage_path(""); // pagePath만 ""로 초기화
					return emptyMenu;
				});
		return targetMenu;
	}

	public Map<String, Object> getContent(Long contentId) {
		return cmsDAO.getContent(contentId);
	}

	public List<Map<String, Object>> getCateList(Long bbsId) {
		return cmsDAO.selectList("CmsMapper.getCateList", bbsId);
	}

	public int saveCateList(Long bbsId, Map<String, Object> data) {
		
		// 1. 기존 리스트 (삭제 대상 산출)
		List<Map<String, Object>> preList = cmsDAO.selectList("CmsMapper.getCateList", bbsId);

		// 2. 받은 data 파싱
		Gson gson = new Gson();
		String cateListJson = (String) data.get("cateList");

		Type listType = new TypeToken<List<Map<String, Object>>>() {}.getType();
		List<Map<String, Object>> newList = gson.fromJson(cateListJson, listType);

		// 3. preList를 cat_id 기준으로 Map으로 변환 (빠른 비교를 위해)
		Map<Long, Map<String, Object>> preMap = preList.stream()
				.collect(Collectors.toMap(
						item -> ((Number)item.get("cat_id")).longValue(),
						item -> item
				));

		// 4. newList를 cat_id 기준으로 Map으로 변환
		Map<Long, Map<String, Object>> newMap = newList.stream()
				.filter(item -> item.get("cat_id") != null && ((Number)item.get("cat_id")).longValue() != -1)
				.collect(Collectors.toMap(
						item -> ((Number)item.get("cat_id")).longValue(),
						item -> item
				));

		// 5. insert 대상: cat_id == -1 인 경우
		List<Map<String, Object>> insertList = newList.stream()
				.filter(item -> ((Number)item.get("cat_id")).longValue() == -1)
				.collect(Collectors.toList());

		// 6. update 대상: cat_id가 존재하고, preList에도 존재하는 경우
		List<Map<String, Object>> updateList = newList.stream()
				.filter(item -> {
					Long catId = ((Number)item.get("cat_id")).longValue();
					return catId != -1 && preMap.containsKey(catId);
				})
				.collect(Collectors.toList());

		// 7. delete 대상: preList에는 있는데, newList에는 없는 경우
		Set<Long> newIds = newMap.keySet(); // 현재 남아있는 id들
		List<Map<String, Object>> deleteList = preList.stream()
				.filter(item -> {
					Long catId = ((Number)item.get("cat_id")).longValue();
					return !newIds.contains(catId);
				})
				.collect(Collectors.toList());

		// 8. 디버깅 출력
		System.out.println("📥 insert 대상: " + insertList);
		System.out.println("✏️ update 대상: " + updateList);
		System.out.println("🗑️ delete 대상: " + deleteList);


		for (Map<String, Object> item : insertList) {
			item.put("bbs_id", bbsId); // insert는 bbs_id도 같이 넣어줘야 함
			cmsDAO.insert("CmsMapper.insertCate", item);
		}

		for (Map<String, Object> item : updateList) {
			cmsDAO.update("CmsMapper.updateCate", item);
		}

		for (Map<String, Object> item : deleteList) {
			cmsDAO.delete("CmsMapper.deleteCate", item);
		}



		return 1;
	}
}
