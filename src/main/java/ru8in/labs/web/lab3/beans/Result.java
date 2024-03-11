package ru8in.labs.web.lab3.beans;

import java.io.Serializable;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import jakarta.persistence.*;
import org.json.JSONObject;

import javax.xml.namespace.QName;


@Entity
@Table(name="results")
public class Result implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    private String sessionId;

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public static class HitMessage {

        private final boolean isHit;
        private final String message;

        HitMessage(boolean isHit, String message) {
            this.isHit = isHit;
            this.message = message;
        }

        public boolean isHit() {
            return isHit;
        }

        public String getMessage() {
            return message;
        }
    }

    private final static String MESSAGE_SUCCESS = "✅ Попадание";
    private final static String MESSAGE_FAIL = "❌ Промах";
    private final static String MESSAGE_ERROR = "⛔ Некорректные данные";

    private Double x;
    private Double y;

    @Temporal(TemporalType.TIMESTAMP)
    private final Date timestamp;
    private String hitMessage;
    private boolean isValid = true;

    public Result(Double x, Double y) {
        this.x = x;
        this.y = y;
        this.timestamp = new Date();
    }

    public Result() {
        this.x = 0.;
        this.y = 0.;
        this.timestamp = new Date();
    }

    public void setX(Double x) {
        this.x = x;
    }

    public void setY(Double y) {
        this.y = y;
    }

    public boolean validate() {
        List<Double> yRange = Arrays.asList(-3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0);

        if (x == null || y == null) {
            return false;
        }
//        else if (!yRange.contains(y)) {
//            return false;
//        }
        else if (y < -3.0 || y > 3.0) {
            return false;
        }
        return true;
    }

    public HitMessage getIsHit(Double r) {
        this.isValid = validate();

        if (!this.isValid) {
            return new HitMessage(false, MESSAGE_ERROR);
        }

        if (x > 0 && y > 0) {
            return new HitMessage(false, MESSAGE_FAIL);
        }
        else if (x <= 0 && y >= 0) {
            if (x >= -Math.abs(r) && y <= r / 2) {
                return new HitMessage(true, MESSAGE_SUCCESS);
            }
        }
        else if (x>=0 && y <= 0) {
            if (Math.sqrt(x*x + y*y) <= r) {
                return new HitMessage(true, MESSAGE_SUCCESS);
            }
        }
        else if (x < 0 && y < 0) {
            if (y >= -(x / 2) - r/2) {
                return new HitMessage(true, MESSAGE_SUCCESS);
            }
        }

        return new HitMessage(false, MESSAGE_FAIL);
    }

    public Double getX() {
        return x;
    }

    public Double getY() {
        return y;
    }

    public String getHitMessage() {
        return this.hitMessage;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    @Override
    public String toString() {
        JSONObject object = new JSONObject();
        object.put("x", this.getX());
        object.put("y", this.getY());
        object.put("isValid", this.isValid);
        object.put("hitMessage", this.getHitMessage());
        object.put("timestamp", this.getTimestamp());
        return object.toString();
    }
}
