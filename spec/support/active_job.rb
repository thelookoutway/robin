RSpec.configure do |config|
  config.before(:each) do
    ApplicationJob.queue_adapter.enqueued_jobs.clear
  end
end

RSpec::Matchers.define :have_been_enqueued_with_arguments do |arguments|
  match do |job_class|
    ActiveJob::Base.queue_adapter.enqueued_jobs.any? do |job|
      job_arguments = ActiveJob::Arguments.deserialize(job[:args]).first
      job[:job] == job_class && arguments.all? do |key, value|
        job_arguments[key] == value
      end
    end
  end

  failure_message do |job_class|
    "expected #{ApplicationJob.queue_adapter.enqueued_jobs.map { |job| ActiveJob::Arguments.deserialize(job[:args]) }} to be #{job_class} and include #{arguments}"
  end
end
