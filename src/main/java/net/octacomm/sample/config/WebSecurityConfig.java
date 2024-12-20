package net.octacomm.sample.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import net.octacomm.sample.service.UserAuthenticationProvider;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

	@Autowired
	UserAuthenticationProvider authenticationProvider;

	// resources 폴더 제외
	@Override
	public void configure(WebSecurity web) throws Exception {
		web.ignoring().antMatchers("/resources/**");
	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests()
				// .antMatchers("/user/**").access("ROLE_USER")
				// .antMatchers("/admin/**").access("ROLE_ADMIN")
				.antMatchers("/", "/login", "/login-error").permitAll()
				.antMatchers("/**").authenticated()
				.and()
		//http.csrf().disable();
		.formLogin()
			.loginPage("/login")
			.loginProcessingUrl("/j_spring_security_check")
			.failureUrl("/login-error")
			.defaultSuccessUrl("/home", true)
			.usernameParameter("userId")
			.passwordParameter("password")
		.and()
		.logout()
			.logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
			.logoutSuccessUrl("/")
			.invalidateHttpSession(true)
		.and()
		.csrf().disable()
		.httpBasic();
		//http.authenticationProvider(authenticationProvider);
	}
	
	@Override
    protected void configure(AuthenticationManagerBuilder auth) {
        auth.authenticationProvider(authenticationProvider);
    }
}
