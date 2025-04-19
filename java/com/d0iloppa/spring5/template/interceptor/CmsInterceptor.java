/**
 * 
 */
package com.d0iloppa.spring5.template.interceptor;

import com.d0iloppa.spring5.template.model.AdminVO;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CmsInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {


    	HttpSession session = request.getSession();
        AdminVO admin = (AdminVO) session.getAttribute("admin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/cms/login");
            return false;
        }

        return true; // 통과
    }
    
}