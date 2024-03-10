package ru8in.labs.web.lab3.beans;

import jakarta.enterprise.context.SessionScoped;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Named;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Map;

@Named()
@SessionScoped
public class ResultList implements Serializable {


    private final ArrayList<Result> results = new ArrayList<>();

    private double r = 1.;
    private Result result = new Result();

    public void addResult() {
        results.add(0, this.result);
        result = new Result();
    }

    public void addResultWithParameters() {
        if(this.result==null) result=new Result(0.0, 0.0);
        try {
            Map<String, String> paramMap = FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();
            result.setX(Double.parseDouble(paramMap.get("x")));
            result.setY(Double.parseDouble(paramMap.get("y")));
            r = Double.parseDouble(paramMap.get("r"));
            results.add(result);
        } catch (RuntimeException exception) {
            System.out.println("error:" + exception.getMessage());
        }
    }

    public void clearResults() {
        if (!results.isEmpty()) results.clear();
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
