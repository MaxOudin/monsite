require "rails_helper"

RSpec.describe GenerateSitemapJob, type: :job do
  let(:task_name) { "sitemap:refresh:no_ping" }
  let(:task) { instance_double(Rake::Task, reenable: true, invoke: true) }

  before do
    allow(Rails.logger).to receive(:info)
    allow(Rake::Task).to receive(:[]).with(task_name).and_return(task)
  end

  it "charge les taches rake uniquement si la tache sitemap n'est pas deja definie" do
    allow(Rake::Task).to receive(:task_defined?).with(task_name).and_return(false)
    expect(Rails.application).to receive(:load_tasks).once

    described_class.perform_now

    expect(task).to have_received(:reenable).once
    expect(task).to have_received(:invoke).once
  end

  it "ne recharge pas toutes les taches rake si la tache sitemap est deja definie" do
    allow(Rake::Task).to receive(:task_defined?).with(task_name).and_return(true)
    expect(Rails.application).not_to receive(:load_tasks)

    described_class.perform_now

    expect(task).to have_received(:reenable).once
    expect(task).to have_received(:invoke).once
  end
end
