export type JobPositionStatus = 'OPEN' | 'CLOSED';

export interface JobPosition {
  id: number;
  title: string;
  description: string | null;
  status: JobPositionStatus;
}

export interface CreateJobPositionRequest {
  title: string;
  description: string;
  status: JobPositionStatus;
}
