package com.bean;

import java.io.Serializable;

public class UtenteBean {
	private int id;
	private String email, pw;
	private boolean isAdmin;
	
    private static final long serialVersionUID = 1L;

	public UtenteBean() {
		
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	
	public boolean getAdmin() {
		return isAdmin;
	}
	
	public void setAdmin(boolean isAdmin) {
		this.isAdmin = isAdmin;
	}
	
    @Override
    public String toString() {
        return "UtenteBean [id=" + id + " email=" + email + ", pw=" + pw + ", isAdmin=" + isAdmin + "]";
    }
}
