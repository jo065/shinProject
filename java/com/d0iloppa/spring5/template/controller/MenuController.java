/**
 * 
 */
package com.d0iloppa.spring5.template.controller;

import com.d0iloppa.spring5.template.config.AppConfig;
import com.d0iloppa.spring5.template.model.HomeVO;
import com.d0iloppa.spring5.template.service.HomeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

@Controller
@RequestMapping("/menu")
public class MenuController {

	
	@Autowired
	private AppConfig appConfig;
	
	@Value("${config.test}")
    private String configTest;
	
    @Autowired
    private HomeService homeService;

    @RequestMapping(value = "menu01.do", method = RequestMethod.GET)
    public ModelAndView home(HttpServletRequest request, HttpServletResponse response, HomeVO homeVO) {
        // viewName
    	ModelAndView mv = new ModelAndView("menu/menu01");
    	
    	String _ct = appConfig.get("config.test", "NONE DATA");
    	
    	String testMsg = String.format("config 비교 : (전역변수)%s : (스코프변수)%s", configTest, _ct);
    	
        mv.addObject("msg", testMsg);
        
        return mv;
    }
    
    @RequestMapping("/sample")
    @ResponseBody
    public Map<String, Object> sampleAPI(HomeVO homeVO){
    	Map<String, Object> result = new HashMap<>();
    	
    	List<HomeVO> sampleList = new ArrayList<>();
    	
    	
    	// data 갯수 3~9 사이
    	int count = ThreadLocalRandom.current().nextInt(3, 10);

        for (int i = 0; i < count; i++) {
            HomeVO vo = new HomeVO();
            vo.setNow(new Date().toString());
            vo.setName(UUID.randomUUID().toString());
            vo.setRandomValue(ThreadLocalRandom.current().nextInt(1, 100)); // 1~99 사이 랜덤
            sampleList.add(vo);
        }

        result.put("data", sampleList);
        result.put("success", true);
    	
    	return result;
    }
    
    
    @RequestMapping("/now")
    @ResponseBody
    public Map<String, Object> now(HomeVO homeVO){
    	Map<String, Object> result = new HashMap<>();
    
    	String now = homeService.getCurrentTime();

        result.put("now", now);
    	
    	return result;
    }
}

