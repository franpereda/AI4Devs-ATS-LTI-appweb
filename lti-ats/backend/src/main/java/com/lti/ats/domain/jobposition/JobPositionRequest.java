package com.lti.ats.domain.jobposition;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class JobPositionRequest {

    @NotBlank
    private String title;

    private String description;

    @NotNull
    private JobPositionStatus status;

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public JobPositionStatus getStatus() { return status; }
    public void setStatus(JobPositionStatus status) { this.status = status; }
}
