package com.bean;

import java.io.Serializable;

public class ProdottoBean implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String nome;
    private String descrizione;
    private double prezzo;
    private String immagine;
    private double media_stelle;
    
    public ProdottoBean() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public double getPrezzo() {
        return prezzo;
    }

    public void setPrezzo(double prezzo) {
        this.prezzo = prezzo;
    }

    public String getImmagine() {
        return immagine;
    }

    public void setImmagine(String immagine) {
        this.immagine = immagine;
    }
    
    public double getMediaStelle() {
    	return media_stelle;
    }
    public void setMediaStelle(double media_stelle) {
    	this.media_stelle = media_stelle;
    }

    @Override
    public String toString() {
        return "ProdottoBean [id=" + id + ", nome=" + nome + ", prezzo=" + prezzo + "]";
    }
}
