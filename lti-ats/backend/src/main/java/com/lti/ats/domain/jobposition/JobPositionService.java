package com.lti.ats.domain.jobposition;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class JobPositionService {

    private final JobPositionRepository repository;

    public JobPositionService(JobPositionRepository repository) {
        this.repository = repository;
    }

    public List<JobPosition> findAll() {
        return repository.findAll();
    }

    public JobPosition findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Job position not found: " + id));
    }

    public JobPosition create(JobPositionRequest request) {
        JobPosition job = new JobPosition(
                request.getTitle(),
                request.getDescription(),
                request.getStatus()
        );
        return repository.save(job);
    }

    public JobPosition update(Long id, JobPositionRequest request) {
        JobPosition job = findById(id);
        job.setTitle(request.getTitle());
        job.setDescription(request.getDescription());
        job.setStatus(request.getStatus());
        return repository.save(job);
    }

    public void delete(Long id) {
        repository.deleteById(id);
    }
}
