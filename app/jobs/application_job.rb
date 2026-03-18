class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  # Capture l'exception dans Sentry après épuisement des retries
  rescue_from(Exception) do |exception|
    Sentry.capture_exception(exception, hint: { job: self.class.name })
    raise exception
  end
end
