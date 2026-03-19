import { useState, useEffect } from 'react';
import type { FormEvent } from 'react';
import type { JobPosition, JobPositionStatus } from './types/JobPosition';
import { getJobs, createJob, deleteJob } from './services/jobPositionService';

export default function App() {
  const [jobs, setJobs] = useState<JobPosition[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [status, setStatus] = useState<JobPositionStatus>('OPEN');
  const [submitting, setSubmitting] = useState(false);

  async function loadJobs() {
    try {
      setLoading(true);
      setError(null);
      setJobs(await getJobs());
    } catch {
      setError('Could not load job positions. Is the backend running on port 8080?');
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    loadJobs();
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    if (!title.trim()) return;
    setSubmitting(true);
    try {
      await createJob({ title: title.trim(), description: description.trim(), status });
      setTitle('');
      setDescription('');
      setStatus('OPEN');
      await loadJobs();
    } catch {
      setError('Failed to create job position.');
    } finally {
      setSubmitting(false);
    }
  }

  async function handleDelete(id: number) {
    try {
      await deleteJob(id);
      setJobs(prev => prev.filter(j => j.id !== id));
    } catch {
      setError('Failed to delete job position.');
    }
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-indigo-700 shadow">
        <div className="max-w-5xl mx-auto px-6 py-4 flex items-center gap-3">
          <span className="text-xl font-bold text-white tracking-tight">LTI ATS</span>
          <span className="text-indigo-300 text-sm">Applicant Tracking System</span>
        </div>
      </header>

      <main className="max-w-5xl mx-auto px-6 py-10 space-y-10">

        {/* Create form */}
        <section className="bg-white rounded-xl border border-gray-200 shadow-sm p-6">
          <h2 className="text-base font-semibold text-gray-800 mb-5">Post a New Job Position</h2>
          <form onSubmit={handleSubmit} className="grid grid-cols-1 gap-4 sm:grid-cols-2">

            <div className="sm:col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Title <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={title}
                onChange={e => setTitle(e.target.value)}
                required
                placeholder="e.g. Senior Software Engineer"
                className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
              />
            </div>

            <div className="sm:col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Description
              </label>
              <textarea
                value={description}
                onChange={e => setDescription(e.target.value)}
                rows={3}
                placeholder="Role responsibilities, requirements, team context..."
                className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Status</label>
              <select
                value={status}
                onChange={e => setStatus(e.target.value as JobPositionStatus)}
                className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
              >
                <option value="OPEN">Open</option>
                <option value="CLOSED">Closed</option>
              </select>
            </div>

            <div className="flex items-end">
              <button
                type="submit"
                disabled={submitting}
                className="w-full bg-indigo-600 hover:bg-indigo-700 disabled:opacity-60 text-white font-medium text-sm rounded-lg px-4 py-2 transition-colors"
              >
                {submitting ? 'Creating…' : 'Create Position'}
              </button>
            </div>
          </form>
        </section>

        {/* Job list */}
        <section>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-base font-semibold text-gray-800">
              Open Positions
              {!loading && (
                <span className="ml-2 text-sm font-normal text-gray-400">({jobs.length})</span>
              )}
            </h2>
            <button
              onClick={loadJobs}
              className="text-sm text-indigo-600 hover:text-indigo-800 font-medium"
            >
              Refresh
            </button>
          </div>

          {error && (
            <div className="bg-red-50 border border-red-200 rounded-lg p-4 mb-4 text-red-700 text-sm">
              {error}
            </div>
          )}

          {loading ? (
            <div className="text-center py-20 text-gray-400 text-sm">Loading…</div>
          ) : jobs.length === 0 ? (
            <div className="text-center py-20 text-gray-400 text-sm">
              No job positions yet. Use the form above to create one.
            </div>
          ) : (
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
              {jobs.map(job => (
                <div
                  key={job.id}
                  className="bg-white rounded-xl border border-gray-200 shadow-sm p-5 flex flex-col gap-3 hover:shadow-md transition-shadow"
                >
                  <div className="flex items-start justify-between gap-2">
                    <h3 className="font-semibold text-gray-900 text-sm leading-snug">
                      {job.title}
                    </h3>
                    <span
                      className={`shrink-0 text-xs font-medium px-2 py-0.5 rounded-full ${
                        job.status === 'OPEN'
                          ? 'bg-green-100 text-green-700'
                          : 'bg-gray-100 text-gray-500'
                      }`}
                    >
                      {job.status}
                    </span>
                  </div>

                  {job.description && (
                    <p className="text-xs text-gray-500 leading-relaxed line-clamp-3">
                      {job.description}
                    </p>
                  )}

                  <div className="mt-auto pt-3 border-t border-gray-100 flex justify-between items-center">
                    <span className="text-xs text-gray-400">#{job.id}</span>
                    <button
                      onClick={() => handleDelete(job.id)}
                      className="text-xs text-red-500 hover:text-red-700 font-medium"
                    >
                      Delete
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </section>
      </main>
    </div>
  );
}
