package com.exam.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

/**
 * 字符编码过滤器
 * 用于解决请求和响应的中文乱码问题
 */
@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("字符编码过滤器初始化完成");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // 设置请求编码
        request.setCharacterEncoding("UTF-8");

        // 设置响应编码
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 继续执行过滤器链
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("字符编码过滤器销毁");
    }
}