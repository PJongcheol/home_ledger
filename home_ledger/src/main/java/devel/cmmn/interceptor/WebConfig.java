package devel.cmmn.interceptor;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	private final LoginInterceptor loginInterceptor;
    private final MenuInterceptor menuInterceptor;

    @Value("${file.upload.path}")
    private String uploadPath;

    public WebConfig(LoginInterceptor loginInterceptor,MenuInterceptor menuInterceptor) {
		this.loginInterceptor = loginInterceptor;
		this.menuInterceptor = menuInterceptor;
	}

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
                .addPathPatterns("/**")
        		.excludePathPatterns(
        			"/login.do",
        			"/login/**",
        			"/api/social/login/**",
        			"/css/**",
        			"/js/**",
        			"/images/**",
        			"/uploads/**",
        			"/error"
        		).order(1);
        registry.addInterceptor(menuInterceptor)
		        .addPathPatterns("/**")
		        .excludePathPatterns(
	        		"/login.do",
        			"/login/**",
        			"/api/social/login/**",
        			"/css/**",
        			"/js/**",
        			"/images/**",
        			"/uploads/**",
        			"/error"
		        )
		        .order(2);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
    	registry.addResourceHandler("/uploads/**").addResourceLocations("file:" + uploadPath);
    }
}