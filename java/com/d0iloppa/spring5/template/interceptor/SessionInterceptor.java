/**
 * 
 */
package com.d0iloppa.spring5.template.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;

import com.d0iloppa.spring5.template.service.CmsService;

public class SessionInterceptor implements HandlerInterceptor {


    @Autowired
    private CmsService cmsService;

    private static final String VISIT_COOKIE_NAME = "visited";
    private static final int COOKIE_EXPIRY = 60 * 60 * 24; // 24시간

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

    	
    	HttpSession session = request.getSession();


        // 1. 요청 타입 필터링 (AJAX, 정적 리소스 제외)
        String acceptHeader = request.getHeader("Accept");
        if (acceptHeader == null || !acceptHeader.contains("text/html")) {
            return true; // HTML 문서가 아닌 경우 무시
        }

        // 2. AJAX 요청 필터링
        String requestType = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(requestType)) {
            return true; // AJAX 요청 무시
        }


        // 3. 리다이렉트 응답 필터링 (302 또는 3xx)
        int statusCode = response.getStatus();
        if (statusCode >= 300 && statusCode < 400) {
            return true; // 리다이렉트 응답 무시
        }


        // 정적 리소스 요청 필터링
        String uri = request.getRequestURI();

        if (uri.contains("/api/") || uri.contains("/cms/menuAccess/")|| uri.contains("bbs/get")|| uri.startsWith("/static/") || uri.startsWith("/resources/") || uri.startsWith("/cms/cdn/") ) {
            return true; // 특정 경로 제외
        }






        cmsService.visitCount();


        return true; // 통과
    }
    
}