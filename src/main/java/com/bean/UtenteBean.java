package com.bean;

public class UtenteBean {
	String email, pw;
	boolean isAdmin;
	public UtenteBean() {
		
	}
	
	String getEmail() {
		return email;
	}
	void setEmail(String email) {
		this.email = email;
	}
	
	String getPw() {
		return pw;
	}
	void setPw(String pw) {
		this.pw = pw;
	}
	
	boolean getAdmin() {
		return isAdmin;
	}
	
	void setAdmin(boolean isAdmin) {
		this.isAdmin = isAdmin;
	}
}
