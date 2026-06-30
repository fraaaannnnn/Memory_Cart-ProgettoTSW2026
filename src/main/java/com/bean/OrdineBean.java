package com.bean;
import java.util.Date;
public class OrdineBean {
	private int id_ordine, id_utente;
	private Date data_ordine;
	private double totale_ordine;
	public enum Stato {
		IN_PREPARAZIONE,
		SPEDITO,
		CONSEGNATO,
		ANNULLATO
	};
	private Stato stato;
	String nome_spedizione, cognome_spedizione, indirizzo_spedizione, citta_spedizione, cap_spedizione;
	
	public OrdineBean() {
		
	}
	
	//getters
	public int getIdOrdine() {
		return id_ordine;
	}
	public int getIdUtente() {
		return id_utente;
		
	}
	public Date getDataOrdine() {
		return data_ordine;
	}
	public double getTotaleOrdine() {
		return totale_ordine;
	}
	public Stato getStato() {
		return stato;
	}
	public String getNomeSpedizione() {
		return nome_spedizione;
	}
	public String getCognomeSpedizione() {
		return cognome_spedizione;
	}
	public String getIndirizzoSpedizione() {
		return indirizzo_spedizione;
	}
	public String getCittaSpedizione() {
		return citta_spedizione;
	}
	public String getCapSpedizione() {
		return cap_spedizione;
	}
	
	//setters
	
	public void setIdOrdine(int id_ordine) {
		this.id_ordine = id_ordine;
	}
	public void setIdUtente(int id_utente) {
		this.id_utente = id_utente;
	}
	public void setDataOrdine(Date data_ordine) {
		this.data_ordine = data_ordine;
	}
	public void setTotaleOrdine(double totale_ordine) {
		this.totale_ordine = totale_ordine;
	}
	public void setStato(Stato stato) {
		this.stato = stato;
	}
	public void setNomeSpedizione(String nome_spedizione) {
		this.nome_spedizione = nome_spedizione;
	}
	public void setCognomeSpedizione(String cognome_spedizione) {
		this.cognome_spedizione = cognome_spedizione;
	}
	public void setIndirizzoSpedizione(String indirizzo_spedizione) {
		this.indirizzo_spedizione = indirizzo_spedizione;
	}
	public void setCittaSpedizione(String citta_spedizione) {
		this.citta_spedizione = citta_spedizione;
	}
	public void setCapSpedizione(String cap_spedizione) {
		this.cap_spedizione = cap_spedizione;
	}
	
	
	@Override 
	public String toString() {
        return "OrdineBean [id_ordine=" + id_ordine +  ",id_utente" + id_utente+",data_ordine="+ data_ordine + ",totale_ordine=" + totale_ordine+ 
        		",stato=" + stato + ",nome_spedizione" + nome_spedizione+ ",cognome_spedizione" + cognome_spedizione+",indirizzo_spedizione" + indirizzo_spedizione + 
        		",citta_spedizione=" + citta_spedizione + ",cap_spedizione=" + cap_spedizione + "]";
	}
	
}
