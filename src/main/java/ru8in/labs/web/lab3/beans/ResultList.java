package ru8in.labs.web.lab3.beans;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.enterprise.context.SessionScoped;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Named;
import jakarta.persistence.*;
import jakarta.servlet.http.HttpSession;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.jpa.HibernatePersistenceProvider;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Map;

@Named()
@SessionScoped
public class ResultList implements Serializable {
    private static final String persistenceUnit = "ResultPU";

    private ArrayList<Result> results = new ArrayList<>();

    private double r = 1.;
    private Result result = new Result();

    private EntityManagerFactory entityManagerFactory;
    private EntityManager entityManager;
    private EntityTransaction transaction;

    public ResultList() {
        connection();
        loadEntries();
    }

    private void connection() {
        entityManagerFactory = Persistence.createEntityManagerFactory(persistenceUnit);
        entityManager = entityManagerFactory.createEntityManager();
        transaction = entityManager.getTransaction();
    }

    private String getSessionId() {
        FacesContext fCtx = FacesContext.getCurrentInstance();
        HttpSession session = (HttpSession) fCtx.getExternalContext().getSession(false);
        return session.getId();
    }

    private void loadEntries() {


        try {
            transaction.begin();
            result.setSessionId(getSessionId()); // Установка JSessionID в объект Result
            Query query = entityManager.createQuery("SELECT res FROM Result res WHERE res.sessionId = :sessionId");
            query.setParameter("sessionId", getSessionId());
            results = (ArrayList<Result>) query.getResultList();
            transaction.commit();
        } catch (RuntimeException exception) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw exception;
        }

    }

    public void addResult() {
        try {
            transaction.begin();
            result.setSessionId(getSessionId()); // Установка JSessionID в объект Result
            entityManager.persist(this.result);
            results.add(this.result);
            result = new Result();
            transaction.commit();
        } catch (RuntimeException exception) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw exception;
        }
    }

    public String clearResults() {
        try {
            transaction.begin();
            Query query = entityManager.createQuery("DELETE FROM Result res WHERE res.sessionId = :sessionId ");
            query.setParameter("sessionId", getSessionId());
            query.executeUpdate();
            results.clear();
            transaction.commit();
        } catch (RuntimeException exception) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            throw exception;
        }
        return "redirect";
    }

    public ArrayList<Result> getResults() {
        return results;
    }
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append("[");
        if (!results.isEmpty()) {
            for (Result res: results) {
                builder.append(res.toString());
                builder.append(",");
            }
            builder.deleteCharAt(builder.length()-1);
        }
        builder.append("]");
        return builder.toString();
    }

    public Result getResult() {
        return result;
    }

    public void setResult(Result result) {
        this.result = result;
    }

    public double getR() {
        return r;
    }

    public void setR(double r) {
        this.r = r;
    }
}
