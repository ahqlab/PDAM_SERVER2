package net.octacomm.sample.service;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Component;

@Component
public class UserAuthenticationProvider implements AuthenticationProvider {

	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		 String id = authentication.getName();
	     String password = authentication.getCredentials().toString();
	     System.err.println("id : " + id);
	     System.err.println("password : " + password);
	     return authenticate(id, password);
	}
	
	
	public Authentication authenticate(String id, String password) throws AuthenticationException {
		return null;
	}
	
	
	@Override
	public boolean supports(Class<?> authentication) {
		// TODO Auto-generated method stub
		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}

}
