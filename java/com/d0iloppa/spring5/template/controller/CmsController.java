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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

@Controller
@RequestMapping("/cms")
public class CmsController {

	
	@Autowired
	private AppConfig appConfig;

	
    @Autowired
    private CmsService cmsService;


    @Value("${cms.file.root}")
    private String cmsFILE_ROOT;




    @GetMapping("/bbs/getBBSInfo/{bbs_id}")
    @ResponseBody
    public Map<String, Object> getBBSInfo(@PathVariable("bbs_id") Long bbs_id) {

        // 게시판 기본 정보 가져오기
        Map<String, Object> bbsInfo = cmsService.getBbsInfo(bbs_id);
        return bbsInfo;
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
    public ModelAndView admin(@RequestParam(value = "menu", required = false, defaultValue = "menuMng") String menu) {
        ModelAndView mv = new ModelAndView("cms/main");

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





}

