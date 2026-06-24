package com.bean;

public class RecensioneBean {
	private int id_recensione;
	private int id_utente;
	private int id_prodotto;
	private int stelle;
	private String recensione;
	private String emailUtente;
	private String nicknameUtente;
	public RecensioneBean() {
		
	}
	
	//getters
	public int getIdRecensione() {
		return id_recensione;
	}
	public int getIdUtente() {
		return id_utente;
	}
	public int getIdProdotto() {
		return id_prodotto;
	}
	public int getStelle() {
		return stelle;
	}
	public String getRecensione() {
		return recensione;
	}
	public String getEmailUtente() {
		return emailUtente;
	}
	public String getNicknameUtente() {
		return nicknameUtente;
	}
	
	
	//setters
	public void setIdRecensione(int id_recensione) {
		this.id_recensione = id_recensione;
	}
		
	public void setIdUtente(int id_utente) {
		this.id_utente = id_utente;
	}
	public void setIdProdotto(int id_prodotto) {
		this.id_prodotto = id_prodotto;
	}
	public void setStelle(int stelle) {
		this.stelle = stelle;
	}
	public void setRecensione(String recensione) {
		this.recensione = recensione;
	}
	public void setEmailUtente(String emailUtente) { 
		this.emailUtente = emailUtente;
	}
	public void setNicknameUtente(String nicknameUtente) {
		this.nicknameUtente = nicknameUtente;
	}
	
	@Override
	public String toString() {
        return "RecensioneBean [id_recensione=" + id_recensione + ", id_utente=" + id_utente + ", id_prodotto=" + id_prodotto + "stelle=" + stelle
        		+ "recensione=" + recensione + " emailUtente=" + emailUtente + " nicknameUtente=" + nicknameUtente + "]";
    }
}
