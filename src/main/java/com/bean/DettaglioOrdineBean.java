package com.bean;

public class DettaglioOrdineBean {
	private int id_dettaglio, id_ordine, id_prodotto, quantita;
	private double prezzo_acquisto;
	
	public DettaglioOrdineBean() {
		
	}
	
	//getters
	public int getIdDettaglio() {
		return id_dettaglio;
	}
	public int getIdOrdine() {
		return id_ordine;
	}
	public int getIdProdotto() {
		return id_prodotto;
	}
	public int getQuantita() {
		return quantita;
	}
	public double getPrezzoAcquisto() {
		return prezzo_acquisto;
	}
	
	//setters
	public void setIdDettaglio(int id_dettaglio) {
		this.id_dettaglio = id_dettaglio;
	}
	public void setIdOrdine(int id_ordine) {
		this.id_ordine = id_ordine;
	}
	public void setIdProdotto(int id_prodotto) {
		this.id_prodotto = id_prodotto;
	}
	public void setQuantita(int quantita) {
		this.quantita = quantita;
	}
	public void setPrezzoAcquisto(double prezzo_acquisto) {
		this.prezzo_acquisto = prezzo_acquisto;
	}
}
