package net.octacomm.sample.config;

import net.octacomm.logger.LoggerBeanPostProcessor;
import net.octacomm.sample.interceptor.ContractInterceptor;
import net.octacomm.sample.interceptor.LogInterceptor;
import net.octacomm.sample.interceptor.LoginInterceptor;
import net.octacomm.sample.view.ReportTenAll;
import net.octacomm.sample.view.ReportTenAllFor1269;
import net.octacomm.sample.view.ReportTenAllFor1338;
import net.octacomm.sample.view.ReportTenAllJh;
import net.octacomm.sample.view.ReportFiveAll;
import net.octacomm.sample.view.ReportFiveAllBy;
import net.octacomm.sample.view.ReportFiveAllFor1269;
import net.octacomm.sample.view.ReportFiveAllFor1338;
import net.octacomm.sample.view.ReportFiveAllJh;
import net.octacomm.sample.view.ReportTen;
import net.octacomm.sample.view.ReportTenJh;
import net.octacomm.sample.view.ReportFive;
import net.octacomm.sample.view.ReportFiveJh;
import net.octacomm.sample.view.MultiFileUsingChartExcelView;
import net.octacomm.sample.view.MultiFileUsingChartExcelView2;
import net.octacomm.sample.view.NewFileUsingChartExcelView;
import net.octacomm.sample.view.NewFileUsingChartExcelView2;

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
@ComponentScan(basePackages = {"net.octacomm.sample.controller", "net.octacomm.sample.interceptor"})
public class WebConfig extends WebMvcConfigurerAdapter {

	@org.springframework.beans.factory.annotation.Autowired
	private ContractInterceptor contractInterceptor;


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
	public AbstractExcelView reportFiveAllFor1269() {
		return new ReportFiveAllFor1269();
	}
	
	@Bean
	public AbstractExcelView reportFiveAllFor1338() {
		return new ReportFiveAllFor1338();
	}
	
	@Bean
	public AbstractExcelView reportTenAllFor1269() {
		return new ReportTenAllFor1269();
	}
	
	
	@Bean
	public AbstractExcelView reportTenAllFor1338() {
		return new ReportTenAllFor1338();
	}
	
	@Bean
	public AbstractExcelView fileUsingChartExcelView() {
		return new NewFileUsingChartExcelView();
	}
	
	@Bean
	public AbstractExcelView fileUsingChartExcelView2() {
		return new NewFileUsingChartExcelView2();
	}
	
	@Bean
	public AbstractExcelView multiFileUsingChartExcelView() {
		return new MultiFileUsingChartExcelView();
	}
	
	@Bean
	public AbstractExcelView multiFileUsingChartExcelView2() {
		return new MultiFileUsingChartExcelView2();
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
		registry.addInterceptor(contractInterceptor)
						.addPathPatterns("/**")
						.excludePathPatterns("/login")
						.excludePathPatterns("/logout")
						.excludePathPatterns("/contract/sign-view")
						.excludePathPatterns("/contract/sign")
						.excludePathPatterns("/contract/pdf")
						.excludePathPatterns("/contract/required")
						.excludePathPatterns("/contract/blocked");
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
						.excludePathPatterns("/mobile/pileselectvalue/piletype/list")
						.excludePathPatterns("/mobile/pileselectvalue/list")
						.excludePathPatterns("/mobile/regist/report2")
						.excludePathPatterns("/mobile/regist/report4")
						.excludePathPatterns("/qr/**")
						.excludePathPatterns("/mobile/regist/report5");
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		
		registry.addResourceHandler("/uploads/**").addResourceLocations("file:///D:/PDGM/uploads/");
		
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
