/**
 * 
 */
package com.d0iloppa.spring5.template.controller;

import com.d0iloppa.spring5.template.config.AppConfig;
import com.d0iloppa.spring5.template.model.HomeVO;
import com.d0iloppa.spring5.template.model.MenuVO;
import com.d0iloppa.spring5.template.service.CmsService;
import com.d0iloppa.spring5.template.service.HomeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

@Controller
@RequestMapping("/")
public class MainController {

	
	@Autowired
	private AppConfig appConfig;


    @Autowired
    private CmsService cmsService;


    @GetMapping("/view/{menu_id}")
    public ModelAndView cmsLayoutPage(@PathVariable("menu_id") Long tree_id) {
        ModelAndView mv = new ModelAndView("cms/layout");

        MenuVO menuVO = cmsService.getPageInfo(tree_id);
        if (menuVO == null) {
            mv.setViewName("error/404");
            return mv;
        }


        // menu_type
        Integer menu_type = menuVO.getPage_type();
        switch (menu_type){
            case 1:{
                // 게시판 타입
                Long bbs_id = menuVO.getBbs_id();

                // 실제 내부에 포함할 JSP (예: cms/bbsContainer.jsp)
                mv.addObject("includePage", "../cms/bbsContainer.jsp");

                // 필요한 게시판 파라미터도 함께 전달
                Map<String, Object> bbsInfo = cmsService.getBbsInfo(bbs_id);

                mv.addObject("bbs_id", bbsInfo.get("bbs_id"));
                mv.addObject("bbs_type", bbsInfo.get("bbs_type"));
                mv.addObject("bbs_name", bbsInfo.get("bbs_name"));


                break;
            }
            case 2: {
                // 정적 페이지 타입
                String page_path = menuVO.getPage_path();

                mv.addObject("includePage", "../" + page_path); // 경로 처리 주의

                break;
            }
        }


        // includePage 찾기


        return mv;
    }





}

