package com.youngbeen.youngService.DTO;

import jakarta.persistence.*;
import lombok.*;

@Table(name = "stock_info")
@Data
public class StockInfoDTO {

    private String srtncd;         // 종목코드
    private String isinCd;         // ISIN 코드
    private String mrktCtg;        // 시장 구분 (KOSPI, KOSDAQ 등)
    private String itmsNm;         // 종목명
    private String crno;           // 법인등록번호
    private String corpNm;         // 법인명
    private boolean isFavorite;

    private String basDt;          // 기준일자 (yyyyMMdd 형태면 String, LocalDate로 바꿀 수도 있음)
    private int clpr;              // 종가
    private int vs;                // 전일 대비
    private double fltRt;          // 등락률 (%)
    private int mkp;               // 시가
    private int hipr;              // 고가
    private int lopr;              // 저가
    private long trqu;             // 거래량
    private long trPrc;            // 거래대금
    private long lstgStCnt;        // 상장주식수
    private long mrktTotAmt;       // 시가총액

    public String getSrtncd() {
        return srtncd;
    }

    public void setSrtncd(String srtncd) {
        this.srtncd = srtncd;
    }

    public String getIsinCd() {
        return isinCd;
    }

    public void setIsinCd(String isinCd) {
        this.isinCd = isinCd;
    }

    public String getMrktCtg() {
        return mrktCtg;
    }

    public void setMrktCtg(String mrktCtg) {
        this.mrktCtg = mrktCtg;
    }

    public String getItmsNm() {
        return itmsNm;
    }

    public void setItmsNm(String itmsNm) {
        this.itmsNm = itmsNm;
    }

    public String getCrno() {
        return crno;
    }

    public void setCrno(String crno) {
        this.crno = crno;
    }

    public String getCorpNm() {
        return corpNm;
    }

    public void setCorpNm(String corpNm) {
        this.corpNm = corpNm;
    }

    public String getBasDt() {
        return basDt;
    }

    public void setBasDt(String basDt) {
        this.basDt = basDt;
    }

    public int getClpr() {
        return clpr;
    }

    public void setClpr(int clpr) {
        this.clpr = clpr;
    }

    public int getVs() {
        return vs;
    }

    public void setVs(int vs) {
        this.vs = vs;
    }

    public double getFltRt() {
        return fltRt;
    }

    public void setFltRt(double fltRt) {
        this.fltRt = fltRt;
    }

    public int getMkp() {
        return mkp;
    }

    public void setMkp(int mkp) {
        this.mkp = mkp;
    }

    public int getHipr() {
        return hipr;
    }

    public void setHipr(int hipr) {
        this.hipr = hipr;
    }

    public int getLopr() {
        return lopr;
    }

    public void setLopr(int lopr) {
        this.lopr = lopr;
    }

    public long getTrqu() {
        return trqu;
    }

    public void setTrqu(long trqu) {
        this.trqu = trqu;
    }

    public long getTrPrc() {
        return trPrc;
    }

    public void setTrPrc(long trPrc) {
        this.trPrc = trPrc;
    }

    public long getLstgStCnt() {
        return lstgStCnt;
    }

    public void setLstgStCnt(long lstgStCnt) {
        this.lstgStCnt = lstgStCnt;
    }

    public long getMrktTotAmt() {
        return mrktTotAmt;
    }

    public void setMrktTotAmt(long mrktTotAmt) {
        this.mrktTotAmt = mrktTotAmt;
    }

    @Override
    public String toString() {
        return "StockInfoDTO{" +
                "srtncd='" + srtncd + '\'' +
                ", isinCd='" + isinCd + '\'' +
                ", mrktCtg='" + mrktCtg + '\'' +
                ", itmsNm='" + itmsNm + '\'' +
                ", crno='" + crno + '\'' +
                ", corpNm='" + corpNm + '\'' +
                ", basDt='" + basDt + '\'' +
                ", clpr=" + clpr +
                ", vs=" + vs +
                ", fltRt=" + fltRt +
                ", mkp=" + mkp +
                ", hipr=" + hipr +
                ", lopr=" + lopr +
                ", trqu=" + trqu +
                ", trPrc=" + trPrc +
                ", lstgStCnt=" + lstgStCnt +
                ", mrktTotAmt=" + mrktTotAmt +
                '}';
    }


    public boolean isFavorite() {
        return isFavorite;
    }

    public void setFavorite(boolean favorite) {
        isFavorite = favorite;
    }
}
