package devel.cmmn.interceptor;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import devel.cmmn.login.vo.LoginVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class LoginInterceptor implements HandlerInterceptor {
	@Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);

        LoginVO loginVo = null;

        if (session != null) {
            loginVo = (LoginVO) session.getAttribute("LoginVO");
        }

        // 로그인 안 되어 있으면
        if (loginVo == null) {
            response.sendRedirect(request.getContextPath() + "/login.do");
            return false; // 컨트롤러 진입 차단
        }

        return true; // 정상 진행
    }
}
