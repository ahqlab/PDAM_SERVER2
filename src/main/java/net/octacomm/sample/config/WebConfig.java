package net.octacomm.sample.config;

import net.octacomm.logger.LoggerBeanPostProcessor;
import net.octacomm.sample.interceptor.LogInterceptor;
import net.octacomm.sample.interceptor.LoginInterceptor;
import net.octacomm.sample.view.ReportTenAll;
import net.octacomm.sample.view.ReportTenAllJh;
import net.octacomm.sample.view.ReportFiveAll;
import net.octacomm.sample.view.ReportFiveAllBy;
import net.octacomm.sample.view.ReportFiveAllJh;
import net.octacomm.sample.view.ReportTen;
import net.octacomm.sample.view.ReportTenJh;
import net.octacomm.sample.view.ReportFive;
import net.octacomm.sample.view.ReportFiveJh;
import net.octacomm.sample.view.NewFileUsingChartExcelView;

import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.mvc.WebContentInterceptor;
import org.springframework.web.servlet.view.BeanNameViewResolver;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.document.AbstractExcelView;
import org.springframework.web.servlet.view.tiles2.TilesConfigurer;
import org.springframework.web.servlet.view.tiles2.TilesViewResolver;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "net.octacomm.sample.controller")
public class WebConfig extends WebMvcConfigurerAdapter {

	@Bean
	public BeanPostProcessor loggerBeanPostProcessor() {
		return new LoggerBeanPostProcessor();
	}
	
	//10회용 전체출력 
	@Bean					 
	public AbstractExcelView reportTenAll() {
		return new ReportTenAll();
	}
	
	//10회용 전체출력 중흥용  (관입량 미출력)
	@Bean
	public AbstractExcelView reportTenAllJh() {
		return new ReportTenAllJh();
	}

	//10회용 개별출력
	@Bean
	public AbstractExcelView reportTen() {
		return new ReportTen();
	}
	
	//10회용 개별출력 중흥용 (관입량 미출력)
	@Bean
	public AbstractExcelView reportTenJh() {
		return new ReportTenJh();
	}
	
	//5회용 전체출력
	@Bean
	public AbstractExcelView reportFiveAll() {
		return new ReportFiveAll();
	}
	
	//5회용 전체출력
	@Bean
	public AbstractExcelView reportFiveAllBy() {
		return new ReportFiveAllBy();
	}

	
	//5회용 전체출력 중흥용 (관입량 미출력)
	@Bean
	public AbstractExcelView reportFiveAllJh() {
		return new ReportFiveAllJh();
	}
	
	//5회용 개별출력
	@Bean
	public AbstractExcelView reportFive() {
		return new ReportFive();
	}
	
	//5회용 개별출력 중흥용 (관입량 미출력)
	@Bean
	public AbstractExcelView reportFiveJh() {
		return new ReportFiveJh();
	}
	
	
	@Bean
	public AbstractExcelView fileUsingChartExcelView() {
		return new NewFileUsingChartExcelView();
	}
	
	@Bean
	public HandlerInterceptor logInterceptor() {
		return new LogInterceptor();
	}
	
   @Bean
   public WebContentInterceptor webChangeInterceptor() {
        WebContentInterceptor webContentInterceptor = new WebContentInterceptor();
        webContentInterceptor.setCacheSeconds(0);
        webContentInterceptor.setUseExpiresHeader(true);
        webContentInterceptor.setUseCacheControlHeader(true);
        webContentInterceptor.setUseCacheControlNoStore(true);
        webContentInterceptor.setSupportedMethods(new String[]{"GET", "POST", "PUT", "DELETE"});
        return webContentInterceptor;
    }
   
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		String patterns[] = new String[] { 
				"/**"
		}; 
		registry.addInterceptor(logInterceptor())
						.addPathPatterns("/**");
		registry.addInterceptor(new LoginInterceptor())
						.addPathPatterns(patterns)
						.excludePathPatterns("/login")
						.excludePathPatterns("/j_spring_security_check")
						.excludePathPatterns("/mobile/device/login")
						.excludePathPatterns("/mobile/device/all/list")
						.excludePathPatterns("/api/get/report/list")
						.excludePathPatterns("/api/get/auth/check")
						.excludePathPatterns("/mobile/regist/report")
						.excludePathPatterns("/mobile/pilestandard/all/list")
						.excludePathPatterns("/mobile/regist/report2")
						.excludePathPatterns("/mobile/regist/report4")
						.excludePathPatterns("/mobile/regist/report5");
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/**").addResourceLocations("/resources/");
	}

	@Override
	public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
		configurer.enable();
	}

	@Bean
	public MultipartResolver multipartResolver() {
		CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
		return multipartResolver;
	}
	
	@Bean
	public InternalResourceViewResolver internalResourceViewResolver() {
		InternalResourceViewResolver resolver = new InternalResourceViewResolver();
		resolver.setPrefix("/WEB-INF/views/");
		resolver.setSuffix(".jsp");
		return resolver;
	}
	
	@Bean
	public TilesConfigurer tilesConfigurer() {
		TilesConfigurer configurer = new TilesConfigurer();
		configurer.setDefinitions( new String[]{"classpath:tilesdef-admin.xml"} );
		return configurer;
	}
	
	@Bean
	public TilesViewResolver tilesViewResolver() {
		TilesViewResolver resolver = new TilesViewResolver();
		resolver.setOrder(1);
		return resolver;
	}
	
	@Bean
	public BeanNameViewResolver beanNameViewResolver() {
		BeanNameViewResolver resolver = new BeanNameViewResolver();
		resolver.setOrder(0);
		return resolver;
	}
}
