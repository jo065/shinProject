/**
 * 
 */
package com.d0iloppa.spring5.template.controller;

import com.d0iloppa.spring5.template.config.AppConfig;
import com.d0iloppa.spring5.template.model.AdminVO;
import com.d0iloppa.spring5.template.model.HomeVO;
import com.d0iloppa.spring5.template.model.MenuVO;
import com.d0iloppa.spring5.template.service.CmsService;
import com.d0iloppa.spring5.template.service.HomeService;
import net.coobird.thumbnailator.Thumbnails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.HandlerExecutionChain;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;


import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.ByteArrayOutputStream;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@Controller
@RequestMapping("/cms")
public class CmsController {

	
	@Autowired
	private AppConfig appConfig;

	
    @Autowired
    private CmsService cmsService;


    @Autowired
    private ServletContext servletContext;

    @Autowired
    private RequestMappingHandlerMapping handlerMapping;



    @Value("${cms.file.root}")
    private String cmsFILE_ROOT;





    @GetMapping("/bbs/getBBSInfo/{bbs_id}")
    @ResponseBody
    public Map<String, Object> getBBSInfo(@PathVariable("bbs_id") Long bbs_id) {

        // 게시판 기본 정보 가져오기
        Map<String, Object> bbsInfo = cmsService.getBbsInfo(bbs_id);
        return bbsInfo;
    }


    @GetMapping("/bbs/getContentsList/{bbs_id}")
    @ResponseBody
    public Map<String, Object> contentsList(@PathVariable("bbs_id") Long bbs_id) {

        Map<String, Object> resultMap = new HashMap<>();

        List<Map<String, Object>> contentsList = cmsService.getContentsList(bbs_id);

        resultMap.put("data", contentsList);


        return resultMap;
    }

    @GetMapping("/bbs/getContent/{content_id}")
    @ResponseBody
    public Map<String, Object> getContent(@PathVariable("content_id") Long content_id) {

        Map<String, Object> resultMap = new HashMap<>();

        Map<String, Object> content = cmsService.getContent(content_id);

        resultMap.put("data", content);

        return resultMap;
    }

    @GetMapping("/bbs/viewContent/{content_id}")
    public ModelAndView moveToBbsContent(@PathVariable("content_id") Long content_id, HttpServletRequest request) {

        ModelAndView mv = new ModelAndView();

        String includePath = "../cms/content/content.jsp";

        mv.addObject("pagePath", includePath);
        mv.addObject("content_id");

        mv.setViewName("cms/cmsStatic");



        return mv;
    }



    @GetMapping("/menuAccess/{menu_id}")
    public ModelAndView menuAccess(@PathVariable("menu_id") Long menuId, HttpServletRequest request) {



        String pagePath = cmsService.findMenu(menuId).getPage_path();

        ModelAndView mv = new ModelAndView();

        // 💡 PathTraversal 공격 막기
        if (pagePath.contains("..")) {
            mv.setViewName("cms/cmsStatic");
            return mv;
        }


        try {
            HttpServletRequestWrapper wrapper = new HttpServletRequestWrapper(request) {
                @Override
                public String getRequestURI() {
                    return pagePath;
                }
            };

            HandlerExecutionChain handler = handlerMapping.getHandler(wrapper);

            if (handler != null) {
                mv.setViewName("redirect:" + pagePath);
            } else {

                String includePath = "../" + (pagePath.startsWith("/") ? pagePath.substring(1) : pagePath);
                mv.addObject("pagePath", includePath);

                mv.setViewName("cms/cmsStatic");
            }
        } catch (Exception e) {
            mv.setViewName("cms/cmsStatic");
        }

        return mv;
    }



    @GetMapping("/cdn/img/{file_id}")
    @ResponseBody
    public ResponseEntity<byte[]> cdn(
            @PathVariable("file_id") Long file_id,
            @RequestParam(value = "thumb", required = false, defaultValue = "false") boolean isThumb
    ) throws IOException {
        Map<String, Object> fileInfo = cmsService.getFileInfo(file_id);
        if (fileInfo == null) {
            return ResponseEntity.notFound().build();
        }

        String relativePath = (String) fileInfo.get("file_path");
        String fullPath = cmsFILE_ROOT + relativePath;

        Path path = Paths.get(fullPath);
        if (!Files.exists(path)) {
            return ResponseEntity.notFound().build();
        }

        String contentType = Files.probeContentType(path);
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            if (isThumb) {
                // 썸네일 생성 (예: 300px 폭으로 리사이징, 비율 유지)
                Thumbnails.of(fullPath)
                        .size(200, 200) // 최대 크기 지정 (비율 유지됨)
                        .keepAspectRatio(true)
                        .toOutputStream(out);
            } else {
                // 원본 그대로
                byte[] fileBytes = Files.readAllBytes(path);
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_TYPE, contentType != null ? contentType : "application/octet-stream")
                        .body(fileBytes);
            }

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_TYPE, contentType != null ? contentType : MediaType.IMAGE_JPEG_VALUE)
                    .body(out.toByteArray());

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }







    @GetMapping("/bbsAdmin/{bbs_id}")
    public ModelAndView bbsAdmin(@PathVariable("bbs_id") Long bbs_id) {

        ModelAndView mv = new ModelAndView("cms/admin_bbsContainer");

        // 게시판 기본 정보 가져오기
        Map<String, Object> bbsInfo = cmsService.getBbsInfo(bbs_id);

        if (bbsInfo == null) {
            // 없는 게시판일 경우 404 또는 에러처리 페이지 이동도 가능
            mv.setViewName("error/404");
            return mv;
        }

        // model에 데이터 추가
        mv.addObject("bbs_id", bbsInfo.get("bbs_id"));
        mv.addObject("bbs_type", bbsInfo.get("bbs_type"));
        mv.addObject("bbs_name", bbsInfo.get("bbs_name"));

        return mv;
    }

    @GetMapping("/bbs/{bbs_id}")
    public ModelAndView bbsView(@PathVariable("bbs_id") Long bbs_id) {

        ModelAndView mv = new ModelAndView("cms/bbsContainer");

        // 게시판 기본 정보 가져오기
        Map<String, Object> bbsInfo = cmsService.getBbsInfo(bbs_id);

        if (bbsInfo == null) {
            // 없는 게시판일 경우 404 또는 에러처리 페이지 이동도 가능
            mv.setViewName("error/404");
            return mv;
        }

        // model에 데이터 추가
        mv.addObject("bbs_id", bbsInfo.get("bbs_id"));
        mv.addObject("bbs_type", bbsInfo.get("bbs_type"));
        mv.addObject("bbs_name", bbsInfo.get("bbs_name"));

        return mv;
    }






    @RequestMapping(value = "login", method = RequestMethod.GET)
    public ModelAndView login(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        AdminVO admin = (AdminVO) session.getAttribute("admin");

        if (admin != null) {
            // admin 세션이 있으면 메인으로 리다이렉트
            return new ModelAndView("redirect:/cms/admin");
        }

        // admin 세션 없으면 로그인 페이지로
        return new ModelAndView("cms/login");
    }


    @RequestMapping(value = "loginPost", method = RequestMethod.POST)
    public ModelAndView loginPost(HttpServletRequest request, HttpServletResponse response, AdminVO vo) {

        AdminVO logined = cmsService.login(vo);

        if(logined != null){
            HttpSession session = request.getSession();
            session.setAttribute("admin", logined);
            return new ModelAndView("redirect:/cms/admin");
        }

        ModelAndView mv = new ModelAndView("cms/login");
        mv.addObject("msg", "로그인 실패 : 아이디/암호를 확인하세요");

        return mv;
    }


    @RequestMapping(value = "logout", method = RequestMethod.GET)
    public ModelAndView logout(HttpServletRequest request, HttpServletResponse response, AdminVO vo) {

        HttpSession session = request.getSession();
        session.removeAttribute("admin");

        return new ModelAndView("cms/login");
    }




    @RequestMapping(value = "admin", method = RequestMethod.GET)
    public ModelAndView admin(
            @RequestParam(value = "menu", required = false, defaultValue = "menuMng") String menu,
            @RequestParam(value = "bbs_id", required = false) Long bbs_id) {
        ModelAndView mv = new ModelAndView("cms/main");


        if (bbs_id != null) {
            mv.addObject("bbs_id", bbs_id); // 필요하다면 JSP에 전달
        }


        Map<String, Object> bbsInfo = cmsService.getBbsInfo(bbs_id);

        if (bbsInfo != null) {
            // model에 데이터 추가
            mv.addObject("bbs_id", bbsInfo.get("bbs_id"));
            mv.addObject("bbs_type", bbsInfo.get("bbs_type"));
            mv.addObject("bbs_name", bbsInfo.get("bbs_name"));
        }





        String contentPage = "menuMng.jsp"; // 기본값

        switch (menu) {
            case "menuMng":
                contentPage = "menuMng.jsp";
                break;
            case "bbsMng":
                contentPage = "bbsMng.jsp";
                break;
            case "config":
                contentPage = "config.jsp";
                break;
            case "manage":
                contentPage = "admin_bbsContainer.jsp";
                break;
            case "editor":
                contentPage = "editor/content.jsp";
                break;
            // default는 그대로 dashboard
        }

        mv.addObject("contentPage", contentPage);
        return mv;
    }

    @GetMapping("api/menuList")
    @ResponseBody
    public List<Map<String, Object>> getMenuTree() {
        return cmsService.getMenuTree();
    }

    @PostMapping("api/saveMenuTree")
    @ResponseBody
    public Map<String, Object> saveMenuTree(@RequestBody List<Map<String, Object>> treeData) {
        Map<String, Object> result = new HashMap<>();

        try {
            cmsService.saveMenuTree(treeData); // 트리 저장 로직 위임
            result.put("success", true);
            result.put("message", "트리 저장 완료");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "저장 실패: " + e.getMessage());
        }

        return result;
    }

    @GetMapping("api/menuFlatList")
    @ResponseBody
    public List<MenuVO> getMenuFlatList() {
        return cmsService.getMenuList(); // 모든 메뉴 SELECT * FROM cms_board_mng
    }

    @GetMapping("api/boardList")
    @ResponseBody
    public List<Map<String, Object>> getBoardList() {
        return cmsService.getBoardList();
    }

    @PostMapping("api/bbsInsert")
    @ResponseBody
    public Map<String, Object> bbsInsert(HttpServletRequest request, @RequestBody Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();


        HttpSession session = request.getSession();
        AdminVO admin = (AdminVO) session.getAttribute("admin");
        String lgn_id = admin.getLgn_id();
        data.put("reg_id", lgn_id);
        data.put("mod_id", lgn_id);


        try {
            cmsService.bbsInsert(data); // 트리 저장 로직 위임
            result.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "저장 실패: " + e.getMessage());
        }

        return result;
    }


    @PostMapping("api/bbsUpdate")
    @ResponseBody
    public Map<String, Object> bbsUpdate(HttpServletRequest request, @RequestBody Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();


        HttpSession session = request.getSession();
        AdminVO admin = (AdminVO) session.getAttribute("admin");
        String lgn_id = admin.getLgn_id();
        data.put("mod_id", lgn_id);


        try {
            cmsService.bbsUpdate(data); // 트리 저장 로직 위임
            result.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "저장 실패: " + e.getMessage());
        }

        return result;
    }

    @PostMapping("api/bbsDelete")
    @ResponseBody
    public Map<String, Object> bbsDelete(HttpServletRequest request, @RequestBody Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();

        String bbsIdList = (String) data.get("bbs_id_list");
        String[] split = bbsIdList.split(",");
        List<Long> _list = new ArrayList<>();
        for(String _id : split){
            Long parse = Long.parseLong(_id);
            _list.add(parse);
        }


        try {
            Map<String, Object> deleteItem = new HashMap<>();

            for(Long id : _list){
                deleteItem.put("bbs_id", id);
                cmsService.bbsDelete(deleteItem);
            }
            result.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "저장 실패: " + e.getMessage());
        }

        return result;
    }


    @PostMapping("api/insertContent")
    @ResponseBody
    public Map<String, Object> insertContent(HttpServletRequest request, @RequestBody Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession();
        AdminVO admin = (AdminVO) session.getAttribute("admin");
        String lgn_id = admin.getLgn_id();
        data.put("reg_id", lgn_id);



        if(cmsService.insertContent(data)>0){
            result.put("success",true);
        }else{
            result.put("success", false);
        }


        return result;
    }




    @PostMapping("/api/uploadImage")
    @ResponseBody
    public Map<String, Object> uploadImage(
            HttpServletRequest request,
            @RequestParam("filepond") MultipartFile file,
            @RequestParam(value = "mode", required = false, defaultValue = "1") int mode) throws IOException {


        HttpSession session = request.getSession();
        AdminVO admin = (AdminVO) session.getAttribute("admin");
        String lgn_id = admin.getLgn_id();

        Long fileId = cmsService.saveTempFile(mode, file, lgn_id); // 저장 후 ID 리턴

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("file_id", fileId);

        return resultMap;
    }


    @PostMapping("api/updateContent")
    @ResponseBody
    public Map<String, Object> updateContent(HttpServletRequest request, @RequestBody Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession();
        AdminVO admin = (AdminVO) session.getAttribute("admin");
        String lgn_id = admin.getLgn_id();
        data.put("reg_id", lgn_id);

        String appened_img = data.getOrDefault("appened_img", "").toString();


        if(cmsService.updateContent(data)>0){
            result.put("success",true);
        }else{
            result.put("success", false);
        }


        return result;
    }






    @DeleteMapping("/api/deleteTempImage")
    @ResponseBody
    public ResponseEntity<?> deleteTempImage(@RequestBody String fileIdStr) {
        try {
            Long fileId = Long.parseLong(fileIdStr);
            cmsService.deleteTempFile(fileId);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }





    @PostMapping("api/deleteContents")
    @ResponseBody
    public Map<String, Object> deleteContents(HttpServletRequest request, @RequestBody Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession();
        AdminVO admin = (AdminVO) session.getAttribute("admin");
        String lgn_id = admin.getLgn_id();
        data.put("reg_id", lgn_id);

        String contentIdList = (String) data.get("contentIdList");
        if(contentIdList == null || contentIdList.trim().length() == 0){
            result.put("success",false);
            return result;
        }

        String[] split = contentIdList.split(",");

        try{

            for(String _content_id : split){
                Long content_id = Long.parseLong(_content_id);
                cmsService.deleteContent(content_id);
            }
            result.put("success",true);
        }catch(Exception e){
            e.printStackTrace();
            result.put("success",false);
        }

        return result;
    }

    @GetMapping("api/getCateInfo/{cat_id}")
    @ResponseBody
    public Map<String, Object> getCateInfo(@PathVariable("cat_id") Integer cat_id) {
        Map<String, Object> result = new HashMap<>();


        Map<String, Object> cateInfo = cmsService.getCateInfo(cat_id);

        result.put("data", cateInfo);

        return result;
    }


    @GetMapping("api/getCateList/{bbs_id}")
    @ResponseBody
    public Map<String, Object> getCateList(@PathVariable("bbs_id") Long bbs_id) {
        Map<String, Object> result = new HashMap<>();


        List<Map<String, Object>> cateList = cmsService.getCateList(bbs_id);

        result.put("data", cateList);


        return result;
    }

    @PostMapping("api/saveCateList/{bbs_id}")
    @ResponseBody
    public Map<String, Object> saveCateList(@PathVariable("bbs_id") Long bbs_id, @RequestBody Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();



        int chk = cmsService.saveCateList(bbs_id, data);

        result.put("data", chk);


        return result;
    }





}

