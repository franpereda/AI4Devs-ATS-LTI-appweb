import type { JobPosition, CreateJobPositionRequest } from '../types/JobPosition';

const BASE_URL = 'http://localhost:8080/api/v1/jobs';

export async function getJobs(): Promise<JobPosition[]> {
  const response = await fetch(BASE_URL);
  if (!response.ok) throw new Error(`GET /jobs failed: ${response.status}`);
  return response.json() as Promise<JobPosition[]>;
}

export async function createJob(request: CreateJobPositionRequest): Promise<JobPosition> {
  const response = await fetch(BASE_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(request),
  });
  if (!response.ok) throw new Error(`POST /jobs failed: ${response.status}`);
  return response.json() as Promise<JobPosition>;
}

export async function deleteJob(id: number): Promise<void> {
  const response = await fetch(`${BASE_URL}/${id}`, { method: 'DELETE' });
  if (!response.ok) throw new Error(`DELETE /jobs/${id} failed: ${response.status}`);
}
