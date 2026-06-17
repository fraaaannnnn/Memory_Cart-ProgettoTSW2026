package com.bean;

import java.io.Serializable;

public class UtenteBean {
	String email, pw;
	boolean isAdmin;
	
    private static final long serialVersionUID = 1L;

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
	
    @Override
    public String toString() {
        return "UtenteBean [email=" + email + ", pw=" + pw + ", prezzo=" + isAdmin + "]";
    }
}
